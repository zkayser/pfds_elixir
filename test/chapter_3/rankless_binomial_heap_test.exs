defmodule RanklessBinomialHeapTest do
  use ExUnit.Case

  describe "link/2" do
    test "creates a binomial tree in heap-sorted order from two binomial trees" do
      tree_1 = %{element: 2, children: []}
      tree_2 = %{element: 5, children: []}

      result = RanklessBinomialHeap.link(tree_1, tree_2)

      assert result.element == 2
      assert length(result.children) == 1
    end

    test "links two binomial trees with differing ranks" do
      rank_one =
        RanklessBinomialHeap.link(%{element: 2, children: []}, %{
          element: 5,
          children: []
        })

      result = RanklessBinomialHeap.link(rank_one, %{element: 3, children: []})

      assert result.element == 2
      assert length(result.children) == 2
    end
  end

  describe "insert/2" do
    test "places a single element into an empty heap as a binomial tree of rank 0" do
      assert RanklessBinomialHeap.insert([], 2) == [%{children: [], element: 2}]
    end

    test "places elements into the heap" do
      heap =
        []
        |> RanklessBinomialHeap.insert(2)
        |> RanklessBinomialHeap.insert(25)
        |> RanklessBinomialHeap.insert(50)
        |> RanklessBinomialHeap.insert(75)
        |> RanklessBinomialHeap.insert(100)
        |> RanklessBinomialHeap.insert(15)

      assert length(heap) == 2
      assert [head | tail] = heap
      assert [last | _] = tail
    end
  end

  describe "merge/2" do
    test "returns the non-empty heap when given an empty and non-empty heap" do
      heap = [%{element: 2, children: []}]
      assert RanklessBinomialHeap.merge(heap, []) == heap
      assert RanklessBinomialHeap.merge([], heap) == heap
    end

    test "creates a new heap from the two heaps passed in" do
      heap_1 = RanklessBinomialHeap.insert([], 0) |> RanklessBinomialHeap.insert(25)
      heap_2 = RanklessBinomialHeap.insert([], 10) |> RanklessBinomialHeap.insert(50)

      expected = [
        %{
          children: [
            %{children: [%{children: [], element: 50}], element: 10},
            %{children: [], element: 25}
          ],
          element: 0,
        }
      ]

      assert RanklessBinomialHeap.merge(heap_1, heap_2) == expected
    end
  end

  describe "find_min/1" do
    test "returns the minimum value from the heap" do
      heap =
        RanklessBinomialHeap.insert([], 100)
        |> RanklessBinomialHeap.insert(20)
        |> RanklessBinomialHeap.insert(10)
        |> RanklessBinomialHeap.insert(50)

      assert RanklessBinomialHeap.find_min(heap) == 10
    end

    test "returns error tuple when given an empty heap" do
      assert {:error, :empty_heap} = RanklessBinomialHeap.find_min([])
    end
  end

  describe "delete_min/1" do
    test "removes the minimum value from the heap and returns a new heap" do
      heap =
        RanklessBinomialHeap.insert([], 100)
        |> RanklessBinomialHeap.insert(20)
        |> RanklessBinomialHeap.insert(10)
        |> RanklessBinomialHeap.insert(50)

      expected = [
        %{children: [], element: 50},
        %{children: [%{children: [], element: 100}], element: 20}
      ]

      result = RanklessBinomialHeap.delete_min(heap)

      assert result == expected
      refute hd(result).element == 10
    end

    test "returns error tuple when given an empty heap" do
      assert {:error, :empty_heap} = RanklessBinomialHeap.delete_min([])
    end
  end

  describe "find_min_direct/1" do
    test "behaves the same as find_min/1" do
      heap = RanklessBinomialHeap.insert([], 100)
        |> RanklessBinomialHeap.insert(20)
        |> RanklessBinomialHeap.insert(10)
        |> RanklessBinomialHeap.insert(50)

      assert RanklessBinomialHeap.find_min_direct(heap) == RanklessBinomialHeap.find_min(heap)
    end

    test "returns an error tuple when given an empty heap" do
      assert {:error, :empty_heap} = RanklessBinomialHeap.find_min_direct([])
    end

    test "returns the only element on one-element, one-tree heaps" do
      assert 1 == RanklessBinomialHeap.insert([], 1) |> RanklessBinomialHeap.find_min_direct()
    end
  end
end
