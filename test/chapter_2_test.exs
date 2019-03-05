defmodule PFDS.Chapter2Test do
  use ExUnit.Case
  import PFDS.Chapter2
  alias PFDS.Chapter2.UnbalancedSet

  @left_sub_tree {:empty, 4, :empty}
  @root_node 5
  @right_sub_tree {:empty, 6, {:empty, 7, {:empty, 8, :empty}}}
  @a_tree {@left_sub_tree, @root_node, @right_sub_tree}

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
      assert {{:empty, 1, :empty}, 4, :empty} = UnbalancedSet.insert(1, @left_sub_tree)
    end

    test "places the element to be inserted in the right sub tree if larger than the root node" do
      assert {:empty, 4, {:empty, 5, :empty}} = UnbalancedSet.insert(5, @left_sub_tree)
    end
  end

  describe "efficient_member/2" do
    test "returns true if the query element is in the tree" do
      assert UnbalancedSet.efficient_member(5, @a_tree)
      assert UnbalancedSet.efficient_member(4, @a_tree)
      assert UnbalancedSet.efficient_member(6, @a_tree)
      assert UnbalancedSet.efficient_member(7, @a_tree)
    end

    test "returns false if the query element is not in the tree" do
      refute UnbalancedSet.efficient_member(1, @a_tree)
      refute UnbalancedSet.efficient_member(0, @a_tree)
      refute UnbalancedSet.efficient_member(100, @a_tree)
    end
  end

  describe "efficient_insert/2" do
    test "returns {:error, :existing_element, original_tree} when inserting an existing element" do
      assert {:existing_element, @a_tree} = UnbalancedSet.efficient_insert(7, @a_tree)
    end

    test "return {:ok, {:empty, element, :empty} when inserting into an empty tree" do
      assert {:ok, {:empty, 2, :empty}} = UnbalancedSet.efficient_insert(2, :empty)
    end
  end

  describe "optimized_insert/2" do
    test "places the element to be inserted in the left sub tree if smaller than the root node" do
      assert {{:empty, 1, :empty}, 4, :empty} = UnbalancedSet.optimized_insert(1, @left_sub_tree)
    end

    test "places the element to be inserted in the right sub tree if larger than the root node" do
      assert {:empty, 4, {:empty, 5, :empty}} = UnbalancedSet.optimized_insert(5, @left_sub_tree)
    end

    test "raises ExistingElementException when inserting an existing element" do
      assert_raise(PFDS.Chapter2.UnbalancedSet.ExistingElementException, fn ->
        UnbalancedSet.optimized_insert(6, @a_tree)
      end)
    end
  end

  describe "complete/2" do
    test "creates a complete binary tree of depth d with element x stored in every node" do
      {x, d} = {1, 4}
      assert {left, 1, right} = complete(x, d)
      assert left == right
      assert {level_2_left, 1, level_2_right} = left
      assert {level_3_left, 1, level_3_right} = level_2_left
      assert {level_4_left, 1, level_4_right} = level_3_left
      assert :empty = level_4_left
    end
  end

  describe "create/2" do
    test "creates balanced trees of arbitrary size, s" do
      assert {{:empty, 1, :empty}, 1, {:empty, 1, :empty}} == balanced(1, 3)
      assert {:empty, 1, {:empty, 1, :empty}} == balanced(1, 2)
    end
  end
end
