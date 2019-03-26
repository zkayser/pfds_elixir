defmodule RanklessBinomialHeap do
  @behaviour Heap
  @moduledoc """
  #-------------------------------------------------------
  ################
  # Exercise 3.6 #
  ################

  Problem Description: Most of the rank annotations in this
  representation of binomial heaps are redundant because we
  know that the children of a node of rank _r_ have ranks
  _r - 1, ..., 0_. Thus, we can remove the rank annotations
  from each node and instead pair each tree at the top-level
  with its rank, i.e.,

    `datatype Tree = Node of Elem x Tree list`
    `type Heap = (int x Tree) list`

  Reimplement binomial heaps with this new representation.
  #-------------------------------------------------------
  """

  @type tree(a) :: %{element: a, children: list(tree(a))}

  @type heap(a) :: list(tree(a))

  @doc """
  Returns an empty rankless binomial heap
  """
  @impl true
  @spec empty() :: heap(any)
  def empty(), do: []

  @doc """
  Link maintains heap order by always linking trees with larger roots
  under trees with smaller roots.
  """
  @spec link(tree(any), tree(any)) :: tree(any)
  def link(%{element: x, children: children} = t1, %{element: y} = t2) when x <= y do
    %{t1 | children: [t2 | children]}
  end

  def link(t1, %{children: children} = t2) do
    %{t2 | children: [t1 | children]}
  end

  @doc """
  Inserts a new element into the heap.

  #------------------------------------------
  The worst case is insertion into a heap of
  size _n = 2^k - 1_, requiring a total of
  k links and O(k) = O(log n) time.
  #------------------------------------------
  """
  @impl true
  @spec insert(heap(any), any) :: heap(any)
  def insert(heap, val), do: insert_(%{element: val, children: []}, heap)
  defp insert_(t, []), do: [t]

  defp insert_(node, [node_2 | remainder] = trees) do
    case rank(node) < rank(node_2) do
      true -> [node | trees]
      false -> node |> link(node_2) |> insert_(remainder)
    end
  end

  defp rank(%{children: children}), do: length(children)

  @doc """
  Merges two heaps together.
  """
  @impl true
  @spec merge(heap(any), heap(any)) :: heap(any)
  def merge(heap, []), do: heap
  def merge([], heap), do: heap

  def merge([%{rank: rank} | _] = heap_1, [%{rank: rank_2} = t2 | smaller]) when rank_2 < rank do
    [t2 | merge(heap_1, smaller)]
  end

  def merge([node_1 | remainder_1] = heap_1, [node_2 | remainder_2]) do
    case rank(node_2) < rank(node_1) do
      true -> [node_2 | merge(heap_1, remainder_2)]
      false -> node_1 |> link(node_2) |> insert_(merge(remainder_1, remainder_2))
    end
  end

  @doc """
  Returns the minimum value in the heap
  """
  @impl true
  @spec find_min(heap(any)) :: {:ok, any} | {:error, :empty_heap}
  def find_min(heap) do
    with {:ok, {min, _}} <- remove_min_tree(heap) do
      {:ok, min.element}
    else
      error -> error
    end
  end

  @doc """
  #-------------------------------------------------------
  ################
  # Exercise 3.5 #
  ################

  Problem Description: Define `find_min` directly rather
  than via a call to `remove_min_tree`.
  #-------------------------------------------------------
  """
  def find_min_direct([]), do: {:error, :empty_heap}
  def find_min_direct([%{element: el}]), do: {:ok, el}

  def find_min_direct(heap) do
    {:ok,
     heap
     |> Enum.reduce(hd(heap.element), fn tree, acc ->
       case tree.element > acc do
         true -> tree.element
         false -> acc
       end
     end)}
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
  @impl true
  @spec delete_min(heap(any)) :: {:ok, heap(any)} | {:error, :empty_heap}
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
