defmodule BinomialHeapTest do
  use ExUnit.Case

  describe "link/2" do
    test "creates a binomial tree in heap-sorted order from two binomial trees" do
      tree_1 = %{element: 2, children: [], rank: 0}
      tree_2 = %{element: 5, children: [], rank: 0}

      result = BinomialHeap.link(tree_1, tree_2)

      assert result.element == 2
      assert result.rank == 1
      assert length(result.children) == 1
    end

    test "links two binomial trees with differing ranks" do
      rank_one =
        BinomialHeap.link(%{element: 2, children: [], rank: 0}, %{
          element: 5,
          children: [],
          rank: 0
        })

      result = BinomialHeap.link(rank_one, %{element: 3, children: [], rank: 0})

      assert result.element == 2
      assert result.rank == 2
      assert length(result.children) == 2
    end
  end

  describe "insert/2" do
    test "places a single element into an empty heap as a binomial tree of rank 0" do
      assert BinomialHeap.insert([], 2) == [%{children: [], element: 2, rank: 0}]
    end

    test "places elements into the heap" do
      heap =
        []
        |> BinomialHeap.insert(2)
        |> BinomialHeap.insert(25)
        |> BinomialHeap.insert(50)
        |> BinomialHeap.insert(75)
        |> BinomialHeap.insert(100)
        |> BinomialHeap.insert(15)

      assert length(heap) == 2
      assert [head | tail] = heap
      assert [last | _] = tail
      assert head.rank == 1
      assert last.rank == 2
    end
  end

  describe "merge/2" do
    test "returns the non-empty heap when given an empty and non-empty heap" do
      heap = [%{element: 2, rank: 0, children: []}]
      assert BinomialHeap.merge(heap, []) == heap
      assert BinomialHeap.merge([], heap) == heap
    end

    test "creates a new heap from the two heaps passed in" do
      heap_1 = BinomialHeap.insert([], 0) |> BinomialHeap.insert(25)
      heap_2 = BinomialHeap.insert([], 10) |> BinomialHeap.insert(50)

      expected = [
        %{
          children: [
            %{children: [%{children: [], element: 50, rank: 0}], element: 10, rank: 1},
            %{children: [], element: 25, rank: 0}
          ],
          element: 0,
          rank: 2
        }
      ]

      assert BinomialHeap.merge(heap_1, heap_2) == expected
    end
  end

  describe "find_min/1" do
    test "returns the minimum value from the heap" do
      heap =
        BinomialHeap.insert([], 100)
        |> BinomialHeap.insert(20)
        |> BinomialHeap.insert(10)
        |> BinomialHeap.insert(50)

      assert {:ok, 10} == BinomialHeap.find_min(heap)
    end

    test "returns error tuple when given an empty heap" do
      assert {:error, :empty_heap} = BinomialHeap.find_min([])
    end
  end

  describe "delete_min/1" do
    test "removes the minimum value from the heap and returns a new heap" do
      heap =
        BinomialHeap.insert([], 100)
        |> BinomialHeap.insert(20)
        |> BinomialHeap.insert(10)
        |> BinomialHeap.insert(50)

      expected = [
        %{children: [], element: 50, rank: 0},
        %{children: [%{children: [], element: 100, rank: 0}], element: 20, rank: 1}
      ]

      assert {:ok, result} = BinomialHeap.delete_min(heap)

      assert result == expected
      refute hd(result).element == 10
    end

    test "returns error tuple when given an empty heap" do
      assert {:error, :empty_heap} = BinomialHeap.delete_min([])
    end
  end

  describe "find_min_direct/1" do
    test "behaves the same as find_min/1" do
      heap =
        BinomialHeap.insert([], 100)
        |> BinomialHeap.insert(20)
        |> BinomialHeap.insert(10)
        |> BinomialHeap.insert(50)

      assert BinomialHeap.find_min_direct(heap) == BinomialHeap.find_min(heap)
    end

    test "returns an error tuple when given an empty heap" do
      assert {:error, :empty_heap} = BinomialHeap.find_min_direct([])
    end

    test "returns the only element on one-element, one-tree heaps" do
      assert {:ok, 1} == BinomialHeap.insert([], 1) |> BinomialHeap.find_min_direct()
    end
  end
end
