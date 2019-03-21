defmodule UnbalancedSetTest do
  use ExUnit.Case

  @left_sub_tree {:empty, 4, :empty}
  @root_node 5
  @right_sub_tree {:empty, 6, {:empty, 7, {:empty, 8, :empty}}}
  @a_tree {@left_sub_tree, @root_node, @right_sub_tree}
  @set %UnbalancedSet{set: @a_tree}

  describe "member?/2" do
    test "returns true if the query element is in the tree" do
      assert UnbalancedSet.member?(5, @set)
      assert UnbalancedSet.member?(4, @set)
      assert UnbalancedSet.member?(6, @set)
      assert UnbalancedSet.member?(7, @set)
    end

    test "returns false if the query element is not in the tree" do
      refute UnbalancedSet.member?(1, @set)
      refute UnbalancedSet.member?(0, @set)
      refute UnbalancedSet.member?(100, @set)
    end
  end

  describe "insert/2" do
    test "places the element to be inserted in the left sub tree if smaller than the root node" do
      assert %UnbalancedSet{set: {{:empty, 1, :empty}, 4, :empty}} =
               UnbalancedSet.insert(1, %UnbalancedSet{set: @left_sub_tree})
    end

    test "places the element to be inserted in the right sub tree if larger than the root node" do
      assert %UnbalancedSet{set: {:empty, 4, {:empty, 5, :empty}}} =
               UnbalancedSet.insert(5, %UnbalancedSet{set: @left_sub_tree})
    end
  end

  describe "efficient_member/2" do
    test "returns true if the query element is in the tree" do
      assert UnbalancedSet.efficient_member(5, @set)
      assert UnbalancedSet.efficient_member(4, @set)
      assert UnbalancedSet.efficient_member(6, @set)
      assert UnbalancedSet.efficient_member(7, @set)
    end

    test "returns false if the query element is not in the tree" do
      refute UnbalancedSet.efficient_member(1, @set)
      refute UnbalancedSet.efficient_member(0, @set)
      refute UnbalancedSet.efficient_member(100, @set)
    end
  end

  describe "efficient_insert/2" do
    test "returns {:error, :existing_element, original_tree} when inserting an existing element" do
      assert {:existing_element, @a_tree} = UnbalancedSet.efficient_insert(7, @set)
    end

    test "return {:ok, {:empty, element, :empty} when inserting into an empty tree" do
      assert {:ok, %UnbalancedSet{set: {:empty, 2, :empty}}} =
               UnbalancedSet.efficient_insert(2, %UnbalancedSet{set: :empty})
    end
  end

  describe "optimized_insert/2" do
    test "places the element to be inserted in the left sub tree if smaller than the root node" do
      assert %UnbalancedSet{set: {{:empty, 1, :empty}, 4, :empty}} =
               UnbalancedSet.optimized_insert(1, %UnbalancedSet{set: @left_sub_tree})
    end

    test "places the element to be inserted in the right sub tree if larger than the root node" do
      assert %UnbalancedSet{set: {:empty, 4, {:empty, 5, :empty}}} =
               UnbalancedSet.optimized_insert(5, %UnbalancedSet{set: @left_sub_tree})
    end

    test "raises ExistingElementException when inserting an existing element" do
      assert_raise(UnbalancedSet.ExistingElementException, fn ->
        UnbalancedSet.optimized_insert(6, @set)
      end)
    end
  end

  describe "new/0" do
    test "creates a new empty set" do
      assert UnbalancedSet.new() == %UnbalancedSet{set: :empty}
    end
  end

  describe "from_list/1" do
    test "creates an unbalanced set from an Elixir list" do
      assert UnbalancedSet.from_list([]) == %UnbalancedSet{set: :empty}
      assert UnbalancedSet.from_list([1]) == %UnbalancedSet{set: {:empty, 1, :empty}}

      assert UnbalancedSet.from_list([5, 4, 6, 7, 8]) ==
               %UnbalancedSet{set: @a_tree}
    end
  end

  describe "Enumerable.UnbalancedSet" do
    test "allows you to call functions from the Enum module" do
      assert 30 ==
               [7, 5, 6, 4, 8]
               |> UnbalancedSet.from_list()
               |> Enum.reduce(0, &Kernel.+/2)
    end

    test "reduces over larger sets" do
      range = 1..200

      assert Enum.reduce(range, 0, &Kernel.+/2) ==
               range
               |> UnbalancedSet.from_list()
               |> Enum.reduce(0, &Kernel.+/2)
    end
  end
end
