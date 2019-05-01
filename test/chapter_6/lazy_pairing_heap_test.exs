defmodule LazyPairingHeapTest do
  use ExUnit.Case
  alias LazyPairingHeap, as: Heap

  describe "empty/0" do
    test "initializes an empty pairing heap" do
      assert :empty = Heap.empty()
    end
  end

  describe "empty?/1" do
    test "returns true if the heap is empty" do
      assert Heap.empty?(Heap.empty())
    end

    test "returns false for non-empty heaps" do
      refute Heap.empty?(%Heap{root: 1})
    end
  end
end
