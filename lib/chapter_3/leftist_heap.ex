defmodule LeftistHeap do
  @moduledoc """
  A Leftist Heap is a heap-ordered binary tree that satisfies the leftist property --
  the rank of any left child is at least as large as the rank of its right sibling.

  The rank of node is defined to be the length of its right spine (i.e., the rightmost
  path from the node in question to an empty or leaf node).

  This definition means that the right spine of any node is always the shortest path
  to an empty node.
  """

  defstruct right: :empty,
            left: :empty,
            element: nil,
            rank: 1

  @type t(a) ::
          %LeftistHeap{right: t(a), left: t(a), element: any(), rank: non_neg_integer()} | :empty

  @spec empty() :: t(any())
  def empty(), do: :empty

  @spec is_empty?(t(any())) :: boolean()
  def is_empty?(:empty), do: true
  def is_empty?(%LeftistHeap{}), do: false

  @spec singleton(any()) :: t(any())
  def singleton(val), do: %LeftistHeap{element: val}

  @spec rank(t(any())) :: non_neg_integer()
  def rank(:empty), do: 0
  def rank(%LeftistHeap{rank: rank}), do: rank

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

  @spec insert(any(), t(any())) :: t(any())
  def insert(val, leftist_heap) do
    val
    |> singleton()
    |> merge(leftist_heap)
  end

  @spec get_min(t(any())) :: {:ok, any()} | {:error, :empty_heap}
  def get_min(:empty), do: {:error, :empty_heap}
  def get_min(%LeftistHeap{element: el}), do: {:ok, el}

  @spec get_min!(t(any)) :: any | none()
  def get_min!(:empty), do: raise(EmptyHeapError)
  def get_min!(%LeftistHeap{element: min}), do: min

  @spec delete_min(t(any())) :: {:ok, t(any())} | {:error, :empty_heap}
  def delete_min(:empty), do: {:error, :empty_heap}
  def delete_min(%LeftistHeap{left: left, right: right}), do: {:ok, merge(left, right)}

  @spec delete_min!(t(any)) :: any | none()
  def delete_min!(:empty), do: raise(EmptyHeapError)
  def delete_min!(%LeftistHeap{left: left, right: right}), do: merge(left, right)
end
