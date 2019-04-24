defmodule LazyBinomialHeapTest do
  alias LazyBinomialHeap, as: Heap
  use ExUnit.Case

  describe "empty/0" do
    test "creates an empty suspended list" do
      assert Heap.empty() == Suspension.create([])
    end
  end

  describe "empty?/1" do
    test "returns true if the heap is empty" do
      assert Heap.empty?(Heap.empty())
    end
  end

  describe "link/2" do
    test "merges two trees together by making the tree with the larger root the leftmost child of the other tree" do
      tree_1 = %{rank: 1, element: 1, children: []}
      tree_2 = %{rank: 1, element: 2, children: []}
      assert Heap.link(tree_1, tree_2) == %{tree_1 | rank: 2, children: [tree_2]}
    end
  end
end
