defmodule HeapTest do
  use ExUnit.Case

  describe "empty/0" do
    test "creates an empty heap" do
      assert %Heap{node: :empty, left: :empty, right: :empty} == Heap.empty()
    end
  end

  describe "is_empty?/1" do
    test "returns true if node is empty" do
      assert Heap.empty() |> Heap.is_empty?()
    end

    test "returns false if node contains a value" do
      refute %Heap{node: 1} |> Heap.is_empty?()
    end
  end

  describe "merge/2" do
    test "returns the first heap if the second is empty" do
      heap_1 = %Heap{node: 4, left: %Heap{node: 5, left: %Heap{node: 6}}, right: %Heap{node: 8}}
      assert Heap.merge(heap_1, Heap.empty()) == heap_1
    end

    test "returns the second heap if the first heap is empty" do
      heap_2 = %Heap{node: 4, left: %Heap{node: 5, left: %Heap{node: 6}}, right: %Heap{node: 8}}
      assert Heap.merge(Heap.empty(), heap_2) == heap_2
    end

    test "merges two small heaps" do
      heap_1 = %Heap{node: 2}
      heap_2 = %Heap{node: 4}

      assert Heap.merge(heap_1, heap_2) == %Heap{node: 2, left: %Heap{node: 4, rank: 0, left: :empty, right: :empty}, right: :empty, rank: 1}
    end
  end
end
