defmodule PairingHeapTest do
  use ExUnit.Case

  describe "singleton/1" do
    test "creates a pairing heap with a single element and no children" do
      assert PairingHeap.singleton(1) == %PairingHeap{root: 1, children: []}
    end
  end

  describe "find_min/1" do
    test "returns the minimum element from the heap" do
      heap = %PairingHeap{root: 4, children: [%PairingHeap{root: 6}, %PairingHeap{root: 7}]}
      assert {:ok, 4} = PairingHeap.find_min(heap)
    end

    test "returns an error tuple if the heap is empty" do
      assert {:error, :empty_heap} = PairingHeap.find_min(:empty)
    end
  end

  describe "merge/2" do
    test "returns the non-empty heap when merging an empty and non-empty heap" do
      assert PairingHeap.merge(PairingHeap.singleton(1), :empty) == PairingHeap.singleton(1)
      assert PairingHeap.merge(:empty, PairingHeap.singleton(1)) == PairingHeap.singleton(1)
    end

    test "makes the tree with the larger root the leftmost child of the tree with the smaller root" do
      merged = PairingHeap.merge(PairingHeap.singleton(1), PairingHeap.singleton(10))
      merged_2 = PairingHeap.merge(PairingHeap.singleton(10), PairingHeap.singleton(1))

      assert merged == %PairingHeap{root: 1, children: [%PairingHeap{root: 10, children: []}]}
      assert merged_2 == %PairingHeap{root: 1, children: [%PairingHeap{root: 10, children: []}]}
    end
  end

  describe "insert/2" do
    test "places the given element into the heap" do
      result_1 = PairingHeap.insert(PairingHeap.singleton(2), 1)

      result_2 =
        PairingHeap.singleton(5)
        |> PairingHeap.insert(10)
        |> PairingHeap.insert(1)
        |> PairingHeap.insert(7)
        |> PairingHeap.insert(4)

      assert result_1.root == 1

      assert result_2.children == [
               %PairingHeap{children: [], root: 4},
               %PairingHeap{children: [], root: 7},
               %PairingHeap{children: [%PairingHeap{children: [], root: 10}], root: 5}
             ]
    end
  end
end
