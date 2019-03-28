defmodule RedBlackTree do
  @moduledoc """
  #-------------------------------------------------------------
  A red-black tree is a binary search tree in which every node
  is colored either red or black.

  All empty nodes are considered to be black, so we do not need
  a color annotation for :empty red-black trees.

  Red-black trees must satisfy the following two invariants:

    *Invariant 1.* No red node has a red child.
    *Invariant 2.* Every path from the root to an empty node
      contains the same number of black nodes.

  Taken together, these two invariants guarantee that the longest
  possible path in a red-black tree, one with alternating black
  and red nodes, is no more than twice as long as the shortest
  possible path: one with only black nodes.
  #-------------------------------------------------------------
  """
  defstruct color: :black,
            left: :empty,
            element: nil,
            right: :empty

  @typep color :: :red | :black
  @type t(a) :: %RedBlackTree{color: color, left: t(a), element: a, right: t(a)} | :empty

  @doc """
  Returns an empty red-black tree.
  """
  @spec empty() :: t(any)
  def empty(), do: :empty

  @doc """
  Returns true if the value passed as the second parameter
  is contained as an element in the red-black tree.
  """
  @spec member?(t(any), any) :: boolean
  def member?(:empty, _), do: false

  def member?(%RedBlackTree{left: left, element: root}, val) when val < root do
    member?(left, val)
  end

  def member?(%RedBlackTree{element: root, right: right}, val) when val > root do
    member?(right, val)
  end

  def member?(%RedBlackTree{}, _), do: true

  @doc """
  Returns an red-black tree with a single node
  containing the value passed in.
  """
  @spec singleton(any) :: t(any)
  def singleton(val), do: %RedBlackTree{element: val}

  @doc """
  #-------------------------------------------------------

  ################
  # Exercise 3.9 #
  ################

  Problem Description: Write a function `from_ord_list` of
  type `Elem list -> Tree` that converts a sorted list with
  no duplicates into a red-black tree. Your function should
  run in O(n) time.

  #-------------------------------------------------------
  """
  @spec from_ord_list(list(any)) :: t(any)
  def from_ord_list([]), do: empty()

  def from_ord_list(list) do
    list
    |> Enum.reduce(RedBlackTree.empty(), fn el, rb_tree -> RedBlackTree.insert(rb_tree, el) end)
  end

  @doc """
  Inserts a value into a red-black tree.
  """
  @spec insert(t(any), any) :: t(any)
  def insert(tree, val) do
    balanced = insert_(tree, val)
    %RedBlackTree{balanced | color: :black}
  end

  defp insert_(:empty, val), do: %RedBlackTree{color: :red, element: val}

  defp insert_(%RedBlackTree{element: root} = tree, val) when val < root do
    %RedBlackTree{tree | left: insert_(tree.left, val)}
    |> lbalance()
  end

  defp insert_(%RedBlackTree{element: root} = tree, val) when val > root do
    %RedBlackTree{tree | right: insert_(tree.right, val)}
    |> rbalance()
  end

  defp insert_(tree, _), do: tree

  #-------------------------------------------------------

  #################
  # Exercise 3.10 #
  #################

  # Problem Description: The `balance` function currently
  # performs several unnecessary tests. For example, when
  # the `insert_` function recurses on the left child,
  # there is no need for balance to test for red-red
  # violations involving the right child.
  #
  # (a) Split `balance` into two functions, `lbalance`
  # and `rbalance`, that test for violations involving
  # the left child and right child, respectively. Replace
  # the calls to `balance` in `insert_` with calls to
  # either `lbalance` or `rbalance`.
  #
  # (b) Extending the same logic one step further, one of
  # the remaining tests on the grandchildren is also
  # unnecessary. Rewrite `insert_` so that it never tests
  # the color of nodes not on the search path.

  #-------------------------------------------------------
  defp lbalance(
    %RedBlackTree{
      color: :black,
      left: %RedBlackTree{
        color: :red,
        left: %RedBlackTree{
          color: :red
        } = red_child,
    } = red_parent
  } = tree) do
    tree
    |> restructure_subtree(:left, red_child.left, red_child.element, red_child.right)
    |> restructure_subtree(:right, red_parent.right, tree.element, tree.right)
    |> replace_root(red_parent.element)
    |> color_red()
  end

  defp lbalance(%RedBlackTree{
    color: :black,
    left: %RedBlackTree{
      color: :red,
      right: %RedBlackTree{color: :red} = red_child
    } = red_parent
  } = tree) do
    tree
    |> restructure_subtree(:left, red_parent.left, red_parent.el, red_child.left)
    |> restructure_subtree(:right, red_child.right, tree.element, tree.right)
    |> replace_root(red_child.element)
    |> color_red()
  end
  defp lbalance(tree), do: tree

  defp rbalance(%RedBlackTree{
    color: :black,
    right: %RedBlackTree{
      color: :red,
      left: %RedBlackTree{
        color: :red
      } = red_child
    } = red_parent
  } = tree) do
    tree
    |> restructure_subtree(:left, tree.left, tree.element, red_child.left)
    |> restructure_subtree(:right, red_child.right, red_parent.element, red_parent.right)
    |> replace_root(red_child.element)
    |> color_red()
  end

  defp rbalance(%RedBlackTree{
    color: :black,
    right: %RedBlackTree{
      color: :red,
      right: %RedBlackTree{
        color: :red
      } = red_child
    } = red_parent
  } = tree) do
    tree
    |> restructure_subtree(:left, tree.left, tree.element, red_parent.left)
    |> restructure_subtree(:right, red_child.left, red_child.element, red_child.right)
    |> replace_root(red_parent.element)
    |> color_red()
  end
  defp rbalance(tree), do: tree

  defp restructure_subtree(%RedBlackTree{} = tree, :left, new_left, new_el, new_right) do
    %RedBlackTree{
      tree
      | left: %RedBlackTree{color: :black, left: new_left, element: new_el, right: new_right}
    }
  end

  defp restructure_subtree(%RedBlackTree{} = tree, :right, new_left, new_el, new_right) do
    %RedBlackTree{
      tree
      | right: %RedBlackTree{color: :black, left: new_left, element: new_el, right: new_right}
    }
  end

  defp replace_root(%RedBlackTree{} = tree, new_root), do: %RedBlackTree{tree | element: new_root}
  defp color_red(%RedBlackTree{color: :black} = tree), do: %RedBlackTree{tree | color: :red}
end
