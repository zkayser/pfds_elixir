defmodule LeftistMaxHeap do
  @moduledoc """
  A Leftist Heap is a heap-ordered binary tree that satisfies the leftist property --
  the rank of any left child is at least as large as the rank of its right sibling.

  The rank of node is defined to be the length of its right spine (i.e., the rightmost
  path from the node in question to an empty or leaf node).

  This definition means that the right spine of any node is always the shortest path
  to an empty node.

  The LeftistMaxHeap as implemented here is a priority queue and maintains the invariant
  that the maximum value is always at the root node of the heap.
  """

  defstruct right: :empty,
            left: :empty,
            element: nil,
            rank: 1

  @type t(a) ::
          %LeftistMaxHeap{right: t(a), left: t(a), element: any(), rank: non_neg_integer()}
          | :empty

  @doc """
  Returns an empty LeftistMaxHeap
  """
  @spec empty() :: t(any())
  def empty(), do: :empty

  @doc """
  Returns true if the heap passed in is empty, false otherwise.
  """
  @spec is_empty?(t(any())) :: boolean()
  def is_empty?(:empty), do: true
  def is_empty?(%LeftistMaxHeap{}), do: false

  @doc """
  Takes a single value and places it as the single node in
  a LeftistMaxHeap.
  """
  @spec singleton(any()) :: t(any())
  def singleton(val), do: %LeftistMaxHeap{element: val}

  @doc """
  Calculates the rank of a LeftistMaxHeap.
  """
  @spec rank(t(any())) :: non_neg_integer()
  def rank(:empty), do: 0
  def rank(%LeftistMaxHeap{rank: rank}), do: rank

  @doc """
  Merges two LeftistHeaps into a single LeftistMaxHeap.
  """
  @spec merge(t(any()), t(any())) :: t(any())
  def merge(:empty, leftist_heap), do: leftist_heap
  def merge(leftist_heap, :empty), do: leftist_heap

  def merge(%LeftistMaxHeap{element: val_1} = h1, %LeftistMaxHeap{element: val_2} = h2)
      when val_1 < val_2,
      do: merge(h2, h1)

  def merge(%LeftistMaxHeap{right: right, left: left} = h1, %LeftistMaxHeap{} = h2) do
    merged = merge(right, h2)
    {rank_left, rank_right} = {rank(left), rank(merged)}

    case rank_left <= rank_right do
      true -> %LeftistMaxHeap{h1 | right: merged, rank: rank_right + 1}
      false -> %LeftistMaxHeap{h1 | left: merged, right: left, rank: rank_left + 1}
    end
  end

  @doc """
  Inserts a single value into a LeftistMaxHeap.
  """
  @spec insert(any(), t(any())) :: t(any())
  def insert(:empty, val), do: singleton(val)

  def insert(%LeftistMaxHeap{} = leftist_heap, val) do
    val
    |> singleton()
    |> merge(leftist_heap)
  end

  # -------------------------------------------------------------

  ################
  # Exercise 3.2 #
  ################

  ## Problem: Define `insert` directly rather than via a call to merge
  @spec insert_direct(any(), t(any)) :: t(any)
  def insert_direct(val, :empty), do: LeftistMaxHeap.singleton(val)

  def insert_direct(val, %LeftistMaxHeap{element: el, right: right, rank: rank} = heap) do
    case val >= el do
      true -> %LeftistMaxHeap{element: val, left: heap}
      false -> %LeftistMaxHeap{heap | right: insert_direct(val, right), rank: rank + 1}
    end
  end

  # -------------------------------------------------------------

  # -------------------------------------------------------------
  ################
  # Exercise 3.3 #
  ################

  ## Problem: Implement a function `from_list` of type `Elem.t list -> Heap` that
  ## produces a leftist heap from an unordered list of elements by first converting
  ## each element into a singleton heap and then merging the heaps until only one
  ## heap remains. Instead of merging the heaps in one right-to-left or left-to-right
  ## pass using `foldr` or `foldl`, merge the heaps in |O(log n)| passes, where each
  ## pass merges adjacent pairs of heaps. Show that `from_list` only takes O(n) time.
  @spec from_list(list(any)) :: t(any)
  def from_list([]), do: :empty

  def from_list(list) do
    list
    |> Enum.map(&LeftistMaxHeap.singleton/1)
    |> merge_pairs()
  end

  defp merge_pairs([heap]), do: heap

  defp merge_pairs([first, second | tail]) do
    [merge(first, second) | tail]
    |> merge_pairs()
  end

  # -------------------------------------------------------------

  @doc """
  Retrieves the minimum value from the LeftistMaxHeap. Since
  the minimum value is always the root node, this operation
  runs in O(1) time.
  """
  @spec find_max(t(any())) :: {:ok, any()} | {:error, :empty_heap}
  def find_max(:empty), do: {:error, :empty_heap}
  def find_max(%LeftistMaxHeap{element: el}), do: {:ok, el}

  @doc """
  Same as `find_max/1`, but raises an EmptyHeapError if it
  tries to operate on an empty heap.
  """
  @spec find_max!(t(any)) :: any | none()
  def find_max!(:empty), do: raise(EmptyHeapError)
  def find_max!(%LeftistMaxHeap{element: min}), do: min

  @doc """
  Deletes the minimum element from the heap and merges the
  root node's left and right children.
  """
  @spec delete_max(t(any())) :: {:ok, t(any())} | {:error, :empty_heap}
  def delete_max(:empty), do: {:error, :empty_heap}
  def delete_max(%LeftistMaxHeap{left: left, right: right}), do: {:ok, merge(left, right)}

  @doc """
  Same as delete_max/1 but raises an EmptyHeapError if it
  tries to operate on an empty heap.
  """
  @spec delete_max!(t(any)) :: any | none()
  def delete_max!(:empty), do: raise(EmptyHeapError)
  def delete_max!(%LeftistMaxHeap{left: left, right: right}), do: merge(left, right)
end
