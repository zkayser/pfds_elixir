defmodule BinomialHeap do
  @moduledoc """
  A binomial heap is a collection of heap-ordered binomial trees in which
  no two trees have the same rank. This collection is represented as a list
  of trees in increasing order of rank.

  Because each binomial tree contains 2^r elements and no two trees have the
  same rank, the trees in a binomial heap of size _n_ correspond exactly to the
  ones in the binary representation of of _n_. For example, the binary representation
  of 21 is 10101 so a binomial heap of size 21 would contain one tree of rank 0, one
  tree of rank 2, and one tree of rank 4 (of sizes 1, 4, and 16, respectively).

  Note that, just as the binary representation of _n_ contains at most |log(n + 1)|
  ones, a binomial heap of size _n_ contains at most |log(n + 1)| trees.
  """

  @type tree(a) :: %{rank: non_neg_integer(), element: a, children: list(tree(a))}

  @type heap(a) :: list(tree(a))

  @doc """
  Link maintains heap order by always linking trees with larger roots
  under trees with smaller roots.
  """
  @spec link(tree(any), tree(any)) :: tree(any)
  def link(%{rank: rank, element: x, children: children} = t1, %{element: y} = t2) when x <= y do
    %{t1 | rank: rank + 1, children: [t2 | children]}
  end

  def link(%{rank: rank} = t1, %{children: children} = t2) do
    %{t2 | rank: rank + 1, children: [t1 | children]}
  end

  @doc """
  Inserts a new element into the heap.

  #------------------------------------------
  The worst case is insertion into a heap of
  size _n = 2^k - 1_, requiring a total of
  k links and O(k) = O(log n) time.
  #------------------------------------------
  """
  @spec insert(any, heap(any)) :: heap(any)
  def insert(heap, value), do: insert_(%{rank: 0, element: value, children: []}, heap)
  defp insert_(t, []), do: [t]

  defp insert_(%{rank: rank} = t, [%{rank: rank_2} | _] = trees) when rank < rank_2 do
    [t | trees]
  end

  defp insert_(t, [tree | smaller]) do
    t
    |> link(tree)
    |> insert_(smaller)
  end

  @doc """
  Merges two heaps together.
  """
  @spec merge(heap(any), heap(any)) :: heap(any)
  def merge(heap, []), do: heap
  def merge([], heap), do: heap

  def merge([%{rank: rank} = t1 | smaller], [%{rank: rank_2} | _] = heap_2) when rank < rank_2 do
    [t1 | merge(smaller, heap_2)]
  end

  def merge([%{rank: rank} | _] = heap_1, [%{rank: rank_2} = t2 | smaller]) when rank_2 < rank do
    [t2 | merge(heap_1, smaller)]
  end

  def merge([t1 | children_1], [t2 | children_2]) do
    t1
    |> link(t2)
    |> insert_(merge(children_1, children_2))
  end

  @doc """
  Returns the minimum value in the heap
  """
  def find_min(heap) do
    with {:ok, {min, _}} <- remove_min_tree(heap) do
      min.element
    else
      error -> error
    end
  end

  @doc """
  Deletes the minimum element from the heap.

  #------------------------------------------
  This is done by returning the children of
  the discarded element to the remaining list
  of binomial trees in the heap. Each list of
  children is _almost_ a valid binomial heap
  in that each is a collection of heap-ordered
  binomial trees of unique rank, but in
  decreasing rather than increasing order of
  rank. We convert the list of children into
  a valid binomial heap by reversing it and
  then merging it with the remaining trees.
  #------------------------------------------
  """
  @spec delete_min(heap(any)) :: heap(any)
  def delete_min(heap) do
    with {:ok, {%{children: children}, remaining}} <- remove_min_tree(heap) do
      merge(Enum.reverse(children), remaining)
    else
      error -> error
    end
  end

  defp remove_min_tree([]), do: {:error, :empty_heap}
  defp remove_min_tree([tree]), do: {:ok, {tree, []}}

  defp remove_min_tree([head | tail]) do
    {:ok, {min_element, min_tree}} = remove_min_tree(tail)

    case head.element > min_element.element do
      true -> {:ok, {min_element, [head | min_tree]}}
      false -> {:ok, {head, tail}}
    end
  end
end
