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
      result = LeftistHeap.merge(left_heap, right_heap)

      assert result == expected
      assert result.rank == 2
    end
  end

  describe "insert/2" do
    test "behaves the same as singleton/1 when the heap is empty" do
      assert LeftistHeap.singleton(1) == LeftistHeap.insert(1, :empty)
    end

    test "places the given element into the heap" do
      starting_heap = LeftistHeap.singleton(2) |> LeftistHeap.merge(LeftistHeap.singleton(3))

      expected = %LeftistHeap{
        element: 1,
        left: %LeftistHeap{element: 2, left: %LeftistHeap{element: 3}},
        right: :empty,
        rank: 1
      }

      starting_heap_2 = LeftistHeap.singleton(10)
      expected_2 = %LeftistHeap{element: 2, left: starting_heap_2}

      assert LeftistHeap.insert(1, starting_heap) == expected
      assert LeftistHeap.insert(2, starting_heap_2) == expected_2
    end
  end

  describe "insert_direct/2" do
    test "behaves the same as insert/2" do
      assert LeftistHeap.singleton(1) == LeftistHeap.insert(1, :empty)

      starting_heap_1 = LeftistHeap.singleton(2) |> LeftistHeap.merge(LeftistHeap.singleton(3))

      expected_1 = %LeftistHeap{
        element: 1,
        left: %LeftistHeap{element: 2, left: %LeftistHeap{element: 3}},
        right: :empty,
        rank: 1
      }

      starting_heap_2 = LeftistHeap.singleton(10)
      expected_2 = %LeftistHeap{element: 2, left: starting_heap_2}

      assert LeftistHeap.insert_direct(1, starting_heap_1) == expected_1
      assert LeftistHeap.insert_direct(2, starting_heap_2) == expected_2
    end
  end

  describe "find_min/1" do
    test "retrieves the minimum element from the heap when the heap is not empty" do
      assert {:ok, 1} = LeftistHeap.find_min(LeftistHeap.singleton(1))

      assert {:ok, 5} =
               LeftistHeap.singleton(5)
               |> LeftistHeap.merge(LeftistHeap.singleton(10))
               |> LeftistHeap.merge(LeftistHeap.singleton(20))
               |> LeftistHeap.merge(LeftistHeap.singleton(15))
               |> LeftistHeap.find_min()
    end

    test "returns an error tuple when the heap is empty" do
      assert {:error, :empty_heap} = LeftistHeap.find_min(:empty)
    end
  end

  describe "find_min!/1" do
    test "raises EmptyHeapError when the heap is empty" do
      assert_raise EmptyHeapError, fn ->
        LeftistHeap.find_min!(:empty)
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

  describe "from_list/1" do
    test "returns an empty heap when given an empty list" do
      assert LeftistHeap.empty() == LeftistHeap.from_list([])
    end

    test "returns a singleton heap when given a list with a singleton element" do
      assert LeftistHeap.singleton(1) == LeftistHeap.from_list([1])
    end

    test "returns a well-formed leftist heap from lists with multiple elements" do
      heap = LeftistHeap.from_list([50, 15, 12, 24, 75])
      assert %LeftistHeap{} = heap
      assert %LeftistHeap{} = heap.right
      assert %LeftistHeap{} = heap.left
      assert heap.rank == 2
    end
  end
end
