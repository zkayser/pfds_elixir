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
      assert WBLeftistHeap.empty == WBLeftistHeap.merge(WBLeftistHeap.empty(), WBLeftistHeap.empty())
    end

    test "returns a single merged heap when given two singleton heaps" do
      expected = %WBLeftistHeap{element: 1, left: %WBLeftistHeap{element: 2}, rank: 2}
      assert expected == WBLeftistHeap.singleton(1) |> WBLeftistHeap.merge(WBLeftistHeap.singleton(2))
    end
  end
end
