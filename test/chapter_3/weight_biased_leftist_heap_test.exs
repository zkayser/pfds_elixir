defmodule WeightBiasedLeftistHeapTest do
  use ExUnit.Case
  alias WeightBiasedLeftistHeap, as: WBLeftistHeap

  describe "empty/0" do
    test "returns an empty heap" do
      assert :empty == WBLeftistHeap.empty()
    end
  end

  describe "is_empty?/1" do
    test "returns true for empty heaps" do
      assert WBLeftistHeap.is_empty?(WBLeftistHeap.empty())
    end

    test "returns false for non-empty heaps" do
      refute WBLeftistHeap.is_empty?(WBLeftistHeap.singleton(1))
    end
  end

  describe "singleton/1" do
    test "returns a heap with a single element and empty children" do
      assert %WBLeftistHeap{element: 1} == WBLeftistHeap.singleton(1)
    end
  end

  describe "merge/2" do
    test "returns the the non-empty heap when given one empty and one non-empty heap" do
      heap = WBLeftistHeap.singleton(1)
      assert heap == WBLeftistHeap.merge(heap, WBLeftistHeap.empty())
      assert heap == WBLeftistHeap.merge(WBLeftistHeap.empty(), heap)
    end

    test "returns an empty heap when given two empty heaps" do
      assert WBLeftistHeap.empty() ==
               WBLeftistHeap.merge(WBLeftistHeap.empty(), WBLeftistHeap.empty())
    end

    test "returns a single merged heap when given two singleton heaps" do
      expected = %WBLeftistHeap{element: 1, left: %WBLeftistHeap{element: 2}, rank: 2}

      assert expected ==
               WBLeftistHeap.singleton(1) |> WBLeftistHeap.merge(WBLeftistHeap.singleton(2))
    end

    test "returns a single merged heap from two larger heaps" do
      heap_1 = WBLeftistHeap.singleton(25)
      heap_2 = WBLeftistHeap.singleton(100)
      heap_3 = WBLeftistHeap.singleton(75)
      heap_4 = WBLeftistHeap.singleton(50)
      heap_5 = WBLeftistHeap.singleton(125)

      expected = %WeightBiasedLeftistHeap{
        element: 25,
        left: %WeightBiasedLeftistHeap{
          element: 50,
          left: %WeightBiasedLeftistHeap{element: 75, left: :empty, rank: 1, right: :empty},
          rank: 2,
          right: :empty
        },
        rank: 5,
        right: %WeightBiasedLeftistHeap{
          element: 100,
          left: %WeightBiasedLeftistHeap{element: 125, left: :empty, rank: 1, right: :empty},
          rank: 2,
          right: :empty
        }
      }

      result =
        heap_1
        |> WBLeftistHeap.merge(heap_2)
        |> WBLeftistHeap.merge(heap_3)
        |> WBLeftistHeap.merge(heap_4)
        |> WBLeftistHeap.merge(heap_5)

      assert result == expected
      assert result.rank == 5
    end
  end
end
