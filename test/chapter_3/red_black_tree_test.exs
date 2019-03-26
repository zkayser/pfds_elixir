defmodule RedBlackTreeTest do
  use ExUnit.Case

  @value "some value"

  describe "member?/2" do
    test "returns false when given an empty tree" do
      refute RedBlackTree.member?(:empty, @value)
    end

    test "returns true if the value contained in the tree" do
      assert RedBlackTree.member?(%RedBlackTree{element: @value}, @value)

      assert RedBlackTree.member?(
               %RedBlackTree{element: "apple", right: %RedBlackTree{element: @value}},
               @value
             )
    end
  end
end
