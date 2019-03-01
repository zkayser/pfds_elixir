defmodule PFDS.Chapter2Test do
  use ExUnit.Case
  import PFDS.Chapter2
  alias PFDS.Chapter2.UnbalancedSet

  @left_sub_tree { :empty, 4, :empty }
  @root_node 5
  @right_sub_tree { :empty, 6, { :empty, 7, :empty } }
  @a_tree { @left_sub_tree, @root_node, @right_sub_tree }

  describe "suffixes/1" do
    test "returns a list of all the suffixes of xs in descending order of length" do
      assert suffixes([1, 2, 3, 4]) == [[1, 2, 3, 4], [2, 3, 4], [3, 4], [4], []]
    end
  end

  describe "member?/2" do
    test "returns true if the query element is in the tree" do
      assert UnbalancedSet.member?(5, @a_tree)
      assert UnbalancedSet.member?(4, @a_tree)
      assert UnbalancedSet.member?(6, @a_tree)
      assert UnbalancedSet.member?(7, @a_tree)
    end

    test "returns false if the query element is not in the tree" do
      refute UnbalancedSet.member?(1, @a_tree)
      refute UnbalancedSet.member?(0, @a_tree)
      refute UnbalancedSet.member?(100, @a_tree)
    end
  end

  describe "insert/2" do
    test "places the element to be inserted in the left sub tree if smaller than the root node" do
      assert { { :empty, 1, :empty }, 4, :empty } = UnbalancedSet.insert(1, @left_sub_tree)
    end

    test "places the element to be inserted in the right sub tree if larger than the root node" do
      assert { :empty, 4, { :empty, 5, :empty }} = UnbalancedSet.insert(5, @left_sub_tree)
    end
  end
end
