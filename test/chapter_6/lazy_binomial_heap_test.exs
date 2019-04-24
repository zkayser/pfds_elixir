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
end
