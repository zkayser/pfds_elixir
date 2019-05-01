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

  describe "merge/2" do
    test "returns the non-empty heap if given one empty and one non-empty heap" do
      heap = %Heap{root: 1}
      assert Heap.merge(heap, Heap.empty()) == heap
      assert Heap.merge(Heap.empty(), heap) == heap
    end

    test "keeps the lower element as root of the new heap when merging" do
      heap = %Heap{root: 1, single_child: :empty, children: Suspension.create(:empty)}
      heap_2 = %Heap{root: 2, single_child: :empty, children: Suspension.create(:empty)}

      result = Heap.merge(heap, heap_2)
      assert result.root == 1
    end

    test "creates a suspension for the child merge step" do
      heap = %Heap{root: 1, single_child: :empty, children: Suspension.create(:empty)}
      heap_2 = %Heap{root: 2, single_child: :empty, children: Suspension.create(:empty)}

      result = Heap.merge(heap, heap_2)
      assert %Suspension{} = result.children
    end
  end

  describe "insert/2" do
    test "places an element into the heap" do
      expected = %Heap{root: 1, single_child: :empty, children: Suspension.create(:empty)}

      assert Heap.insert(Heap.empty(), 1) == expected
    end
  end

  describe "singleton/1" do
    test "creates a heap with a single element and no children" do
      assert Heap.singleton(1) == %Heap{
               root: 1,
               single_child: :empty,
               children: Suspension.create(:empty)
             }
    end
  end

  describe "find_min/1" do
    test "returns the minimum element wrapped in an ok tuple for non-empty heaps" do
      heap =
        Heap.empty()
        |> Heap.insert(2)
        |> Heap.insert(6)
        |> Heap.insert(1)
        |> Heap.insert(14)
        |> Heap.insert(9)

      assert {:ok, 1} = Heap.find_min(heap)
    end

    test "returns an error tuple for empty heaps" do
      assert {:error, :empty} = Heap.find_min(Heap.empty())
    end
  end
end
