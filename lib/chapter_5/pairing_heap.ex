defmodule PairingHeap do
  @moduledoc """

  #----------------------------------------------------------
  Pairing heaps are heap-ordered multi-way trees.

  In terms of running time of the operations available on
  pairing heaps, `find_min/1`, `insert/2`, and `merge/2`
  all run in O(1) worst-case time; however, `delete_min/1`
  can run in O(n) time in the worst case.

  In analogy to Splay Trees, however, `insert/1`, `merge/2`,
  and `delete_min/1` can all run in O(log n) amortized time.

  Pairing heaps are nearly as fast Splay Heaps for applications
  that do not use the `merge` function, and much faster for
  applications that do. Like splay heaps, however, they should
  be used only for applications that do not take advantage of
  persistence.
  #----------------------------------------------------------
  """

  defstruct root: nil, children: []
  @type t(a) :: :empty | %PairingHeap{root: a, children: list(t(a))}

  @doc """
  Creates a pairing heap with a single element
  and no children.
  """
  @spec singleton(any) :: t(any)
  def singleton(el), do: %PairingHeap{root: el}

  @doc """
  Finds and returns the minimum element in the heap.
  """
  @spec find_min(t(any)) :: {:ok, any} | {:error, :empty_heap}
  def find_min(%PairingHeap{root: el}), do: {:ok, el}
  def find_min(:empty), do: {:error, :empty_heap}

  @doc """
  Merges two heaps together
  """
  @spec merge(t(any), t(any)) :: t(any)
  def merge(:empty, heap), do: heap
  def merge(heap, :empty), do: heap

  def merge(%PairingHeap{root: x} = h1, %PairingHeap{root: y} = h2) when x <= y do
    %PairingHeap{h1 | children: [h2 | h1.children]}
  end

  def merge(h1, h2) do
    %PairingHeap{h2 | children: [h1 | h2.children]}
  end

  @doc """
  Places the given element in the heap.
  """
  @spec insert(t(any), any) :: t(any)
  def insert(heap, element) do
    element
    |> PairingHeap.singleton()
    |> PairingHeap.merge(heap)
  end

  @doc """
  Removes the root of the heap and then merges the
  children in two passes: one merging the children
  in pairs from left to right, and then merging the
  resulting trees from right to left.
  """
  @spec delete_min(t(any)) :: {:ok, t(any)} | {:error, :empty_heap}
  def delete_min(:empty), do: {:error, :empty_heap}
  def delete_min(%PairingHeap{root: _, children: children}), do: {:ok, merge_pairs(children)}

  defp merge_pairs([]), do: :empty
  defp merge_pairs([heap]), do: heap

  defp merge_pairs([heap_1, heap_2 | tail]) do
    merge(heap_1, heap_2)
    |> merge(merge_pairs(tail))
  end

  defmodule BinTree do
    @moduledoc """

    #-------------------------------------------------------

    ################
    # Exercise 5.8 #
    ################

    Any multiway tree can be represented as a binary tree by
    converting every multiway node into a binary node whose
    left child represents the leftmost child of the multiway
    node and whose right child represents the sibling immediately
    to the right of the multiway node. If either the leftmost
    child or the right sibling of the multiway node is missing,
    then the corresponding field in the binary node is empty.
    Applied to pairing heaps, this transformation yields half-
    ordered binary trees in which the element at each node is
    no greater than any element in its left subtree.

    #-------------------------------------------------------
    """

    defstruct el: nil, left: :empty, right: :empty
    @type t(a) :: :empty | %BinTree{el: a, left: t(a), right: t(a)}
  end

  @doc """
  Converts a pairing heap from a multiway node
  representation into a binary tree representation.
  """
  @spec to_binary(t(any)) :: BinTree.t(any)
  def to_binary(:empty), do: :empty

  def to_binary(%PairingHeap{root: root, children: children}) do
    %BinTree{el: root, left: sub_trees(children)}
  end

  defp sub_trees([%PairingHeap{root: root, children: children}]) do
    %BinTree{el: root, left: sub_trees(children)}
  end

  defp sub_trees([%PairingHeap{root: root, children: children} | rest]) do
    %BinTree{el: root, right: sub_trees(rest), left: sub_trees(children)}
  end

  defp sub_trees([]), do: :empty
end
