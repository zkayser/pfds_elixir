defmodule LazyBinomialHeap do
  import Lazy

  @typep tree(a) :: %{rank: non_neg_integer(), element: a, children: list(tree(a))}
  @type heap(a) :: list(tree(a))
  @type t(a) :: Suspension.t(heap(a))

  @doc """
  Initializes an empty heap
  """
  @spec empty() :: t(any)
  def empty, do: Suspension.create([])

  @doc """
  Returns true if the heap is empty
  """
  @spec empty?(t(any)) :: boolean
  def empty?(heap) do
    case Suspension.force(heap) do
      [] -> true
      _ -> false
    end
  end

  @doc """
  Links two trees together, placing the tree with the larger
  root as the leftmost child of the tree with the smaller root.
  """
  @spec link(tree(any), tree(any)) :: tree(any)
  def link(%{element: x, children: c1} = tree_1, %{element: y, children: c2} = tree_2) do
    case x <= y do
      true -> %{tree_1 | rank: tree_1.rank + 1, children: [tree_2 | c1]}
      _ -> %{tree_2 | rank: tree_1.rank + 1, children: [tree_1 | c2]}
    end
  end

  @doc """
  Inserts a binomial tree into the heap
  """
  @spec insert_tree(tree(any), list(tree(any))) :: list(tree(any))
  def insert_tree(tree, []), do: [tree]

  def insert_tree(%{rank: r1} = tree, [%{rank: r2} = tree_ | trees] = heap) do
    case r1 < r2 do
      true -> [tree | heap]
      _ -> tree |> link(tree_) |> insert_tree(trees)
    end
  end

  @doc """
  Inserts an element into the heap
  """
  @spec insert(t(any), any) :: t(any)
  deflazy insert(heap, el) do
    insert_tree(%{rank: 0, element: el, children: []}, heap)
  end

  @doc """
  Merges two heaps together
  """
  @spec mrg(heap(any), heap(any)) :: heap(any)
  def mrg(heap, []), do: heap
  def mrg([], heap), do: heap

  def mrg([%{rank: r1} = t1 | trees_1] = heap_1, [%{rank: r2} = t2 | trees_2] = heap_2) do
    cond do
      r1 < r2 -> [t1 | mrg(trees_1, heap_2)]
      r2 < r1 -> [t2 | mrg(heap_1, trees_2)]
      true -> link(t1, t2) |> insert_tree(mrg(trees_1, trees_2))
    end
  end
end
