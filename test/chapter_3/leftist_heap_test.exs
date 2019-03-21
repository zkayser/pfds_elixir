defmodule LeftistHeapTest do
  use ExUnit.Case

  describe "empty/0" do
    test "creates an empty leftist heap" do
      assert :empty == LeftistHeap.empty()
    end
  end

  describe "is_empty?/1" do
    test "returns true for :empty" do
      assert LeftistHeap.is_empty?(:empty)
    end

    test "returns false for other leftist heaps" do
      refute LeftistHeap.is_empty?(%LeftistHeap{element: "a value"})
    end
  end

  describe "singleton/1" do
    test "creates a new LeftistHeap with a single value" do
      assert %LeftistHeap{element: 1} = LeftistHeap.singleton(1)
    end
  end

  describe "merge/2" do
    test "returns non-empty leftist heap if one is empty" do
      assert LeftistHeap.merge(%LeftistHeap{element: 2}, :empty) == %LeftistHeap{element: 2}
      assert LeftistHeap.merge(:empty, %LeftistHeap{element: 1}) == %LeftistHeap{element: 1}

      assert LeftistHeap.merge(LeftistHeap.empty(), %LeftistHeap{element: 3}) == %LeftistHeap{
               element: 3
             }

      assert LeftistHeap.merge(%LeftistHeap{element: 4}, LeftistHeap.empty()) == %LeftistHeap{
               element: 4
             }
    end

    test "handles two singletons" do
      expected = %LeftistHeap{
        element: 2,
        left: %LeftistHeap{element: 10, rank: 1},
        rank: 1,
        right: :empty
      }

      heap_1 = LeftistHeap.singleton(2)
      heap_2 = LeftistHeap.singleton(10)
      result = LeftistHeap.merge(heap_1, heap_2)

      assert result == expected
    end

    test "handles leftist_heaps with more than one root" do
      expected = %LeftistHeap{
        element: 2,
        rank: 2,
        right: LeftistHeap.singleton(10),
        left: %LeftistHeap{
          element: 3,
          left: LeftistHeap.singleton(6),
          right: LeftistHeap.singleton(9),
          rank: 2
        }
      }

      left_heap = %LeftistHeap{
        element: 2,
        left: LeftistHeap.singleton(10),
        right: LeftistHeap.singleton(9),
        rank: 2
      }

      right_heap = %LeftistHeap{element: 3, left: LeftistHeap.singleton(6)}

      assert LeftistHeap.merge(left_heap, right_heap) == expected
    end
  end

  describe "get_min/1" do
    test "retrieves the minimum element from the heap when the heap is not empty" do
      assert {:ok, 1} = LeftistHeap.get_min(LeftistHeap.singleton(1))

      assert {:ok, 5} =
               LeftistHeap.singleton(5)
               |> LeftistHeap.merge(LeftistHeap.singleton(10))
               |> LeftistHeap.merge(LeftistHeap.singleton(20))
               |> LeftistHeap.merge(LeftistHeap.singleton(15))
               |> LeftistHeap.get_min()
    end

    test "returns an error tuple when the heap is empty" do
      assert {:error, :empty_heap} = LeftistHeap.get_min(:empty)
    end
  end

  describe "get_min!/1" do
    test "raises EmptyHeapError when the heap is empty" do
      assert_raise EmptyHeapError, fn ->
        LeftistHeap.get_min!(:empty)
      end
    end
  end

  describe "delete_min/1" do
    test "returns the left and the right branch of root when the heap is not empty" do
      heap =
        1
        |> LeftistHeap.singleton()
        |> LeftistHeap.merge(LeftistHeap.singleton(2))
        |> LeftistHeap.merge(LeftistHeap.singleton(3))

      expected_heap =
        2
        |> LeftistHeap.singleton()
        |> LeftistHeap.merge(LeftistHeap.singleton(3))

      assert {:ok, expected_heap} == LeftistHeap.delete_min(heap)
    end

    test "returns an error tuple when the heap is empty" do
      assert {:error, :empty_heap} = LeftistHeap.delete_min(:empty)
    end
  end

  describe "delete_min!/1" do
    test "returns left and right branch of the root when the heap is not empty" do
      heap =
        1
        |> LeftistHeap.singleton()
        |> LeftistHeap.merge(LeftistHeap.singleton(2))
        |> LeftistHeap.merge(LeftistHeap.singleton(3))

      expected_heap =
        2
        |> LeftistHeap.singleton()
        |> LeftistHeap.merge(LeftistHeap.singleton(3))

      assert expected_heap == LeftistHeap.delete_min!(heap)
    end

    test "raises EmptyHeapError when the heap is empty" do
      assert_raise EmptyHeapError, fn ->
        LeftistHeap.delete_min!(:empty)
      end
    end
  end
end
