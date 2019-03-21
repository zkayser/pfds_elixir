defmodule LeftistHeap do
  @moduledoc """
  A Leftist Heap is a heap-ordered binary tree that satisfies the leftist property --
  the rank of any left child is at least as large as the rank of its right sibling.

  The rank of node is defined to be the length of its right spine (i.e., the rightmost
  path from the node in question to an empty or leaf node).

  This definition means that the right spine of any node is always the shortest path
  to an empty node.

  The LeftistHeap as implemented here is a priority queue and maintains the invariant
  that the minimum value is always at the root node of the heap.
  """

  defstruct right: :empty,
            left: :empty,
            element: nil,
            rank: 1

  @type t(a) ::
          %LeftistHeap{right: t(a), left: t(a), element: any(), rank: non_neg_integer()} | :empty

  @doc """
  Returns an empty LeftistHeap
  """
  @spec empty() :: t(any())
  def empty(), do: :empty

  @doc """
  Returns true if the heap passed in is empty, false otherwise.
  """
  @spec is_empty?(t(any())) :: boolean()
  def is_empty?(:empty), do: true
  def is_empty?(%LeftistHeap{}), do: false

  @doc """
  Takes a single value and places it as the single node in
  a LeftistHeap.
  """
  @spec singleton(any()) :: t(any())
  def singleton(val), do: %LeftistHeap{element: val}

  @doc """
  Calculates the rank of a LeftistHeap.
  """
  @spec rank(t(any())) :: non_neg_integer()
  def rank(:empty), do: 0
  def rank(%LeftistHeap{rank: rank}), do: rank

  @doc """
  Merges two LeftistHeaps into a single LeftistHeap.
  """
  @spec merge(t(any()), t(any())) :: t(any())
  def merge(:empty, leftist_heap), do: leftist_heap
  def merge(leftist_heap, :empty), do: leftist_heap

  def merge(%LeftistHeap{element: val_1} = h1, %LeftistHeap{element: val_2} = h2)
      when val_1 > val_2,
      do: merge(h2, h1)

  def merge(%LeftistHeap{right: right, left: left} = h1, %LeftistHeap{} = h2) do
    merged = merge(right, h2)
    {rank_left, rank_right} = {rank(left), rank(merged)}

    case rank_left >= rank_right do
      true -> %LeftistHeap{h1 | right: merged, rank: rank_right + 1}
      false -> %LeftistHeap{h1 | left: merged, right: left, rank: rank_left + 1}
    end
  end

  @doc """
  Inserts a single value into a LeftistHeap.
  """
  @spec insert(any(), t(any())) :: t(any())
  def insert(val, leftist_heap) do
    val
    |> singleton()
    |> merge(leftist_heap)
  end

  @doc """
  Retrieves the minimum value from the LeftistHeap. Since
  the minimum value is always the root node, this operation
  runs in O(1) time.
  """
  @spec get_min(t(any())) :: {:ok, any()} | {:error, :empty_heap}
  def get_min(:empty), do: {:error, :empty_heap}
  def get_min(%LeftistHeap{element: el}), do: {:ok, el}

  @doc """
  Same as `get_min/1`, but raises an EmptyHeapError if it
  tries to operate on an empty heap.
  """
  @spec get_min!(t(any)) :: any | none()
  def get_min!(:empty), do: raise(EmptyHeapError)
  def get_min!(%LeftistHeap{element: min}), do: min

  @doc """
  Deletes the minimum element from the heap and merges the
  root node's left and right children.
  """
  @spec delete_min(t(any())) :: {:ok, t(any())} | {:error, :empty_heap}
  def delete_min(:empty), do: {:error, :empty_heap}
  def delete_min(%LeftistHeap{left: left, right: right}), do: {:ok, merge(left, right)}

  @doc """
  Same as delete_min/1 but raises an EmptyHeapError if it
  tries to operate on an empty heap.
  """
  @spec delete_min!(t(any)) :: any | none()
  def delete_min!(:empty), do: raise(EmptyHeapError)
  def delete_min!(%LeftistHeap{left: left, right: right}), do: merge(left, right)
end
