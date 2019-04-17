defmodule SplayHeapTest do
  use ExUnit.Case

  describe "singleton/1" do
    test "creates a SplayHeap with a single element" do
      assert SplayHeap.singleton(1) == %SplayHeap{el: 1}
    end
  end

  describe "insert/2" do
    test "places the given element at the root of the tree" do
      heap =
        %SplayHeap{left: %SplayHeap{el: 2}, el: 4, right: %SplayHeap{el: 6}}
        |> SplayHeap.insert(3)

      assert heap == %SplayHeap{
               left: SplayHeap.singleton(2),
               el: 3,
               right: %SplayHeap{
                 el: 4,
                 right: SplayHeap.singleton(6)
               }
             }
    end

    test "should place all smaller elements in the left subtree and larger elements in the right subtree" do
      heap =
        SplayHeap.singleton(5)
        |> SplayHeap.insert(10)
        |> SplayHeap.insert(7)

      assert heap.left.el == 5
      assert heap.right.el == 10
      assert heap.el == 7
    end
  end
end
