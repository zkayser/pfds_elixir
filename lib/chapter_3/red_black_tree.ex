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

  @spec empty() :: t(any)
  def empty(), do: :empty

  @spec member?(t(any), any) :: boolean
  def member?(:empty, _), do: false

  def member?(%RedBlackTree{left: left, element: root}, val) when val < root do
    member?(left, val)
  end

  def member?(%RedBlackTree{element: root, right: right}, val) when val > root do
    member?(right, val)
  end

  def member?(%RedBlackTree{}, _), do: true

  @spec singleton(any) :: t(any)
  def singleton(val), do: %RedBlackTree{element: val}

  @spec insert(t(any), any) :: t(any)
  def insert(tree, val) do
    balanced = insert_(tree, val)
    %RedBlackTree{balanced | color: :black}
  end

  defp insert_(:empty, val), do: %RedBlackTree{color: :red, element: val}

  defp insert_(%RedBlackTree{element: root} = tree, val) when val < root do
    %RedBlackTree{tree | left: insert_(tree.left, val)}
    |> balance()
  end

  defp insert_(%RedBlackTree{element: root} = tree, val) when val > root do
    %RedBlackTree{tree | right: insert_(tree.right, val)}
    |> balance()
  end

  defp insert_(tree, _), do: tree

  defp balance(
         %RedBlackTree{
           color: :black,
           left: %RedBlackTree{
             color: :red,
             left: %RedBlackTree{
               color: :red,
               element: x,
               left: red_child_left,
               right: red_child_right
             },
             element: y,
             right: red_parent_right
           },
           element: root,
           right: root_right
         } = tree
       ) do
    tree
    |> restructure_subtree(:left, red_child_left, x, red_child_right)
    |> restructure_subtree(:right, red_parent_right, root, root_right)
    |> replace_root(y)
    |> color_red()
  end

  defp balance(
         %RedBlackTree{
           color: :black,
           left: %RedBlackTree{
             color: :red,
             left: red_parent_left,
             element: red_parent_el,
             right: %RedBlackTree{
               color: :red,
               left: red_child_left,
               element: red_child_el,
               right: red_child_right
             }
           },
           element: root,
           right: root_right
         } = tree
       ) do
    tree
    |> restructure_subtree(:left, red_parent_left, red_parent_el, red_child_left)
    |> restructure_subtree(:right, red_child_right, root, root_right)
    |> replace_root(red_child_el)
    |> color_red()
  end

  defp balance(
         %RedBlackTree{
           color: :black,
           left: root_left,
           element: root,
           right: %RedBlackTree{
             color: :red,
             left: %RedBlackTree{
               color: :red,
               left: red_child_left,
               element: red_child_el,
               right: red_child_right
             },
             element: red_parent_el,
             right: red_parent_right
           }
         } = tree
       ) do
    tree
    |> restructure_subtree(:left, root_left, root, red_child_left)
    |> restructure_subtree(:right, red_child_right, red_parent_el, red_parent_right)
    |> replace_root(red_child_el)
    |> color_red()
  end

  defp balance(
         %RedBlackTree{
           color: :black,
           left: root_left,
           element: root,
           right: %RedBlackTree{
             color: :red,
             left: red_parent_left,
             element: red_parent_el,
             right: %RedBlackTree{
               color: :red,
               left: red_child_left,
               element: red_child_el,
               right: red_child_right
             }
           }
         } = tree
       ) do
    tree
    |> restructure_subtree(:left, root_left, root, red_parent_left)
    |> restructure_subtree(:right, red_child_left, red_child_el, red_child_right)
    |> replace_root(red_parent_el)
    |> color_red()
  end

  defp balance(tree), do: tree

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
