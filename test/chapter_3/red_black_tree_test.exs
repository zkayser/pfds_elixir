defmodule RedBlackTreeTest do
  use ExUnit.Case

  @value "some value"

  describe "empty/0" do
    test "returns an empty red-black tree" do
      assert RedBlackTree.empty() == :empty
    end
  end

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

  describe "singleton/1" do
    test "places the given element into a single-node red-black tree" do
      assert RedBlackTree.singleton(1) == %RedBlackTree{
               color: :black,
               element: 1,
               left: :empty,
               right: :empty
             }
    end
  end

  describe "insert/2" do
    test "creates a singleton red black tree skeleton when inserting into an empty tree" do
      assert RedBlackTree.insert(:empty, 1) == RedBlackTree.singleton(1)
    end

    test "creates a new red black tree from inserted elements" do
      tree =
        RedBlackTree.insert(:empty, 10)
        |> RedBlackTree.insert(20)
        |> RedBlackTree.insert(15)

      expected = %RedBlackTree{
        color: :black,
        element: 15,
        left: %RedBlackTree{color: :black, element: 10},
        right: %RedBlackTree{color: :black, element: 20}
      }

      assert tree == expected
    end

    test "creates red nodes when trees need balancing" do
      tree =
        :empty
        |> RedBlackTree.insert(10)
        |> RedBlackTree.insert(15)
        |> RedBlackTree.insert(20)
        |> RedBlackTree.insert(5)

      expected = %RedBlackTree{
        color: :black,
        element: 15,
        left: %RedBlackTree{
          color: :black,
          element: 10,
          left: %RedBlackTree{color: :red, element: 5, left: :empty, right: :empty},
          right: :empty
        },
        right: %RedBlackTree{color: :black, element: 20, left: :empty, right: :empty}
      }

      assert tree == expected
    end
  end

  describe "from_ord_list/1" do
    test "returns an empty red-black tree when given an empty list" do
      assert RedBlackTree.empty() == RedBlackTree.from_ord_list([])
    end

    test "constructs a red-black tree from the given list" do
      expected = %RedBlackTree{
        color: :black,
        element: 5,
        left: %RedBlackTree{element: 1},
        right: %RedBlackTree{
          element: 10,
          right: %RedBlackTree{color: :red, element: 15}
        }
      }

      assert expected == RedBlackTree.from_ord_list([1, 5, 10, 15])
    end
  end

  describe "depth/1" do
    test "returns one for empty trees" do
      assert RedBlackTree.depth(RedBlackTree.empty()) == 1
    end

    test "returns the depth of the tree" do
      assert RedBlackTree.depth(RedBlackTree.singleton(1)) == 2

      tree =
        RedBlackTree.singleton(2)
        |> RedBlackTree.insert(3)
        |> RedBlackTree.insert(4)

      tree_2 =
        RedBlackTree.singleton(1)
        |> RedBlackTree.insert(2)
        |> RedBlackTree.insert(3)
        |> RedBlackTree.insert(4)
        |> RedBlackTree.insert(5)

      assert RedBlackTree.depth(tree) == 3
      assert RedBlackTree.depth(tree_2) == 4
    end
  end
end
