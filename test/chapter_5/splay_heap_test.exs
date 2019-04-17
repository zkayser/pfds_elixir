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

  describe "find_min/1" do
    test "returns the smallest element in the heap" do
      heap =
        SplayHeap.singleton(100)
        |> SplayHeap.insert(10)
        |> SplayHeap.insert(500)
        |> SplayHeap.insert(1)
        |> SplayHeap.insert(50)
        |> SplayHeap.insert(1000)
        |> SplayHeap.insert(200)

      assert SplayHeap.find_min(heap) == 1
    end
  end

  describe "delete_min/1" do
    test "removes the minimum node from the heap" do
      heap =
        SplayHeap.singleton(5)
        |> SplayHeap.insert(1)
        |> SplayHeap.insert(10)

      assert SplayHeap.delete_min(heap) == %SplayHeap{
               left: :empty,
               el: 5,
               right: %SplayHeap{el: 10}
             }
    end
  end

  describe "merge/2" do
    test "returns the non-empty heap when merging one empty and one non-empty heap" do
      heap_1 = SplayHeap.singleton(1)
      heap_2 = :empty

      assert heap_1 == SplayHeap.merge(heap_1, heap_2)
      assert heap_1 == SplayHeap.merge(heap_2, heap_1)
    end

    test "combines two splay heaps into a single heap" do
      heap_1 = SplayHeap.singleton(5) |> SplayHeap.insert(2)
      heap_2 = SplayHeap.singleton(3) |> SplayHeap.insert(10) |> SplayHeap.insert(1)

      assert SplayHeap.merge(heap_1, heap_2) == %SplayHeap{
               el: 2,
               left: %SplayHeap{el: 1, left: :empty, right: :empty},
               right: %SplayHeap{
                 el: 3,
                 left: :empty,
                 right: %SplayHeap{
                   el: 5,
                   left: :empty,
                   right: %SplayHeap{el: 10, left: :empty, right: :empty}
                 }
               }
             }
    end
  end
end
