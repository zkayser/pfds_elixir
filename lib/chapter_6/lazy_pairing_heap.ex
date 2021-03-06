defmodule LazyPairingHeap do
  @moduledoc """
  #-----------------------------------------------------------------

  A lazy implementation of the PairingHeap data structure with
  bounds that are asymptotically as efficient in a persistent
  setting as the original implementation.

  In the original implementation, deleting the minimum element
  discards the root and merges its children in pairs using the
  `merge_pairs/2` function. In a persistent environment, if we
  deleted the minimum element of the same heap twice, then the
  `merge_pairs/2` function would be called twice, thereby duplicating
  work and destroying amortized efficiency.

  To circumvent this duplication of efforts in a persistent
  environment, we use lazy evaluation and memoization by
  changing the heap's representation of children elements from
  a list of heaps to suspended heaps: Suspension.t(heap).

  Because `merge_pairs/2` operates on pairs of children, we
  extend the suspension with two children at once and include
  an extra heap field in each node to hold any partnerless children.
  This field will be empty if the number of children is even.

  #-----------------------------------------------------------------
  """
  alias __MODULE__, as: PairingHeap
  defstruct [:root, :single_child, :children]

  @type t(a) ::
          :empty
          | %__MODULE__{
              root: a,
              single_child: t(a),
              children: Suspension.t(t(a))
            }

  @doc """
  Initializes an empty pairing heap.
  """
  @spec empty :: t(any)
  def empty, do: :empty

  @doc """
  Returns true only for empty heaps.
  """
  @spec empty?(t(any)) :: boolean
  def empty?(:empty), do: true
  def empty?(%PairingHeap{}), do: false

  @doc """
  Creates a pairing heap with a single root
  element and no children.
  """
  @spec singleton(any) :: t(any)
  def singleton(element) do
    %PairingHeap{
      root: element,
      single_child: empty(),
      children: Suspension.create(empty())
    }
  end

  @doc """
  Merges two pairing heaps together.
  """
  @spec merge(t(any), t(any)) :: t(any)
  def merge(heap, :empty), do: heap
  def merge(:empty, heap), do: heap

  def merge(%PairingHeap{root: x} = heap_1, %PairingHeap{root: y} = heap_2) when x <= y do
    link(heap_1, heap_2)
  end

  def merge(heap_1, heap_2), do: link(heap_2, heap_1)

  defp link(%PairingHeap{single_child: :empty} = heap, heap_2) do
    %PairingHeap{heap | single_child: heap_2}
  end

  defp link(heap, heap_2) do
    %PairingHeap{
      heap
      | single_child: empty(),
        children:
          Suspension.create(__MODULE__, :merge, [
            merge(heap_2, heap.single_child),
            Suspension.force(heap.children)
          ])
    }
  end

  @doc """
  Inserts an element into the pairing heap.
  """
  @spec insert(t(any), any) :: t(any)
  def insert(heap, element) do
    singleton(element)
    |> merge(heap)
  end

  @doc """
  Finds the minimum element in the heap
  and returns it wrapped in an ok tuple,
  or returns an error tuple if the heap
  is empty.
  """
  @spec find_min(t(any)) :: {:ok, any} | {:error, :empty}
  def find_min(:empty), do: {:error, :empty}
  def find_min(%PairingHeap{root: root}), do: {:ok, root}

  @doc """
  Removes the minimum element from the heap
  and merges the children together, wrapping
  the result in an ok tuple for non-empty
  heaps. Returns an error tuple if the heap
  is empty.
  """
  @spec delete_min(t(any)) :: {:ok, t(any)} | {:error, :empty}
  def delete_min(:empty), do: {:error, :empty}

  def delete_min(%PairingHeap{single_child: single, children: children}) do
    {:ok, merge(single, Suspension.force(children))}
  end
end
