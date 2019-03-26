defmodule WeightBiasedLeftistHeap do
  alias __MODULE__, as: WBLeftistHeap
  @behaviour Heap

  @moduledoc """

  ################
  # Exercise 3.4 #
  ################

  # -------------------------------------------------------------
  Problem Description: Weight-biased leftist heaps are an
  alternative to leftist heaps that replace the leftist property
  with the _weight-biased leftist property_: the size of any left
  child is at least as large as the size of its right sibling.

  (a) Prove that the right spine of a weight-biased leftist heap
      contains at most |log(n + 1)| elements.
  (b) Modify the implementation [of `LeftistHeap`] to obtain
      weight-biased leftist heaps.
  (c) Currently, `merge` operates in two passes: a top-down pass
      consisting of calls to `merge`, and a bottom-up pass
      consisting of calls to the helper function `makeT` (NOTE:
      the aforementioned implementation is from the Standard ML
      example from the book). Modify `merge` for weight-biased
      leftist heaps to operate in a single, top-down pass.
  (d) What advantages would the top-down version of `merge`
      have in a lazy environment? In a concurrent environment?
  # -------------------------------------------------------------
  """

  defstruct rank: 1,
            element: nil,
            left: :empty,
            right: :empty

  @type t(a) ::
          :empty
          | %WBLeftistHeap{
              rank: pos_integer(),
              left: t(a),
              right: t(a)
            }

  @impl true
  @spec empty() :: t(any)
  def empty(), do: :empty

  @spec is_empty?(t(any)) :: boolean()
  def is_empty?(:empty), do: true
  def is_empty?(%WBLeftistHeap{}), do: false

  @spec singleton(any) :: t(any)
  def singleton(val), do: %WBLeftistHeap{element: val}

  @impl true
  @spec merge(t(any), t(any)) :: t(any)
  def merge(:empty, %WBLeftistHeap{} = heap), do: heap
  def merge(%WBLeftistHeap{} = heap, :empty), do: heap
  def merge(:empty, :empty), do: empty()

  def merge(%WBLeftistHeap{element: x} = h1, %WBLeftistHeap{element: y} = h2) when x > y do
    merge(h2, h1)
  end

  def merge(%WBLeftistHeap{right: right, left: left} = h1, %WBLeftistHeap{} = h2) do
    case rank(left) >= rank(right) + rank(h2) do
      true -> %WBLeftistHeap{h1 | right: merge(right, h2), rank: rank(h1) + rank(h2)}
      false -> %WBLeftistHeap{h1 | left: merge(right, h2), right: left, rank: rank(h1) + rank(h2)}
    end
  end

  @impl true
  @spec find_min(t(any)) :: {:ok, any} | {:error, :empty_heap}
  def find_min(%WBLeftistHeap{element: x}), do: {:ok, x}
  def find_min(:empty), do: {:error, :empty_heap}

  @impl true
  @spec delete_min(t(any)) :: {:ok, t(any)} | {:error, :empty_heap}
  def delete_min(%WBLeftistHeap{right: right, left: left}), do: {:ok, merge(left, right)}
  def delete_min(:empty), do: {:error, :empty_heap}

  @impl true
  @spec insert(t(any), any) :: t(any)
  def insert(:empty, val), do: singleton(val)

  def insert(%WBLeftistHeap{} = heap, val) do
    val
    |> singleton()
    |> merge(heap)
  end

  defp rank(:empty), do: 0
  defp rank(%WBLeftistHeap{rank: rank}), do: rank
end
