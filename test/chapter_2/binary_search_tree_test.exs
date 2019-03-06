defmodule BinarySearchTreeTest do
  use ExUnit.Case

  describe "complete/2" do
    test "creates a complete binary tree of depth d with element x stored in every node" do
      {x, d} = {1, 4}
      assert {left, 1, right} = BinarySearchTree.complete(x, d)
      assert left == right
      assert {level_2_left, 1, level_2_right} = left
      assert {level_3_left, 1, level_3_right} = level_2_left
      assert {level_4_left, 1, level_4_right} = level_3_left
      assert :empty = level_4_left
    end
  end

  describe "create/2" do
    test "creates balanced trees of arbitrary size, s" do
      assert {{:empty, 1, :empty}, 1, {:empty, 1, :empty}} == BinarySearchTree.balanced(1, 3)
      assert {:empty, 1, {:empty, 1, :empty}} == BinarySearchTree.balanced(1, 2)
    end
  end
end
