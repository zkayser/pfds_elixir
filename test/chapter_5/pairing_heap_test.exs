defmodule PairingHeapTest do
  use ExUnit.Case

  describe "singleton/1" do
    test "creates a pairing heap with a single element and no children" do
      assert PairingHeap.singleton(1) == %PairingHeap{root: 1, children: []}
    end
  end

  describe "find_min/1" do
    test "returns the minimum element from the heap" do
      heap = %PairingHeap{root: 4,
      children: [%PairingHeap{root: 6}, %PairingHeap{root: 7}]
    }
      assert {:ok, 4} = PairingHeap.find_min(heap)
    end

    test "returns an error tuple if the heap is empty" do
      assert {:error, :empty_heap} = PairingHeap.find_min(:empty)
    end
  end
end
