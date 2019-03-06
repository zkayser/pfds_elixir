defmodule BinarySearchTree do
  alias PFDS.Chapter2

  @doc """
  Exercise 2.5 A)
  Sharing can be also be useful within a single object, not just between objects. For example,
  if the two subtrees of a given node are identical, then they can be represented by the same tree.

  a) Using this idea, write a function `complete` of type `Elem -> Int -> Tree` where `complete(x, d)`
  creates a binary tree of depth `d` with `x` stored in every node. (Of course, this function makes no
  sense for the set abstraction, but it can be a useful auxilary function for other abstractions, such
  as bags.) This function should run in `O(d)` time.
  """
  @spec complete(Chapter2.el, integer()) :: Chapter2.tree()
  def complete(_x, 0), do: :empty

  def complete(x, d) do
    sub_tree = complete(x, d - 1)
    {sub_tree, x, sub_tree}
  end

  @doc """
  Exercise 2.5 B)

  Extend the above `complete` function to create balanced trees of arbitrary size. These trees will
  not always be complete binary trees, but should be as balanced as possible: for any given node,
  the two subtrees should differ in size by at most one. This function should run in `O(log n)` time.
  """
  @spec balanced(Chapter2.el, integer) :: Chapter2.tree()
  def balanced(_x, 0), do: :empty

  def balanced(x, size) do
    {sub_tree_1, sub_tree_2} = create_2(x, div(size - 1, 2))

    case rem(size, 2) == 0 do
      true -> {sub_tree_1, x, sub_tree_2}
      false -> {sub_tree_1, x, sub_tree_1}
    end
  end

  defp create_2(_x, size) when size < 0, do: {:empty, :empty}
  defp create_2(x, 0), do: {:empty, {:empty, x, :empty}}

  defp create_2(x, size) when rem(size, 2) != 0 do
    {sub_tree_1, sub_tree_2} = create_2(x, div(size - 1, 2))
    {{sub_tree_1, x, sub_tree_1}, {sub_tree_1, x, sub_tree_2}}
  end

  defp create_2(x, size) do
    {sub_tree_1, sub_tree_2} = create_2(x, div(size - 2, 2))
    {{sub_tree_1, x, sub_tree_2}, {sub_tree_2, x, sub_tree_2}}
  end
end
