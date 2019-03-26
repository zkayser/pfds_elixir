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
  @type tree(a) :: %RedBlackTree{color: color, left: tree(a), element: a, right: tree(a)}

  @spec member?(tree(any), any) :: boolean
  def member?(:empty, _), do: false

  def member?(%RedBlackTree{left: left, element: root}, val) when val < root do
    member?(left, val)
  end

  def member?(%RedBlackTree{element: root, right: right}, val) when val > root do
    member?(right, val)
  end

  def member?(%RedBlackTree{}, _), do: true
end
