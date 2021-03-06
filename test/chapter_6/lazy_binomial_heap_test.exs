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

  describe "insert_tree/2" do
    test "given an empty list of trees, will place the passed in tree into a singleton heap" do
      tree = %{rank: 1, element: 1, children: []}
      assert Heap.insert_tree(tree, []) == [tree]
    end

    test "places the tree passed in as the leftmost element in the trees list if its rank is less than the first tree in the heap" do
      tree = %{rank: 1, element: 1, children: []}
      assert Heap.insert_tree(tree, [%{rank: 2, element: 2, children: []}]) |> hd() == tree
    end

    test "links the tree being passed in with the first tree in the list before inserting into the heap" do
      tree = %{rank: 1, element: 1, children: []}
      tree_2 = %{rank: 1, element: 2, children: []}
      linked = Heap.link(tree, tree_2)
      assert Heap.insert_tree(tree, [tree_2]) == [linked]
    end
  end

  describe "insert/2" do
    test "places an element as part of a singleton tree into an heap" do
      tree = %{rank: 0, element: 1, children: []}

      assert []
             |> Suspension.create()
             |> Heap.insert(1)
             |> Lazy.eval()
             |> Suspension.force() == [tree]
    end

    test "places an element into a non-empty heaps" do
      expected = [
        %{children: [], element: 5, rank: 0},
        %{
          children: [
            %{children: [%{children: [], element: 4, rank: 0}], element: 3, rank: 1},
            %{children: [], element: 2, rank: 0}
          ],
          element: 1,
          rank: 2
        }
      ]

      assert Heap.empty()
             |> Heap.insert(1)
             |> Heap.insert(2)
             |> Heap.insert(3)
             |> Heap.insert(4)
             |> Heap.insert(5)
             |> Lazy.eval()
             |> Suspension.force() == expected
    end
  end

  describe "find_min/1" do
    test "returns the minimum value in non-empty heaps" do
      assert {:ok, 1} =
               Heap.empty()
               |> Heap.insert(5)
               |> Heap.insert(8)
               |> Heap.insert(1)
               |> Heap.insert(4)
               |> Lazy.eval()
               |> Heap.find_min()
    end

    test "returns an error tuple when given an empty heap" do
      assert {:error, :empty} = Heap.empty() |> Heap.find_min()
    end
  end

  describe "mrg/2" do
    test "returns the non-empty heap when merging one empty and one non-empty heap" do
      heap = [%{rank: 1, element: 1, children: []}]
      assert Heap.mrg(heap, []) == heap
      assert Heap.mrg([], heap) == heap
    end

    test "places the leading binomial tree with the smaller rank as the leftmost tree in the resulting heap" do
      tree = %{rank: 1, element: 1, children: []}
      tree_2 = %{rank: 2, element: 2, children: []}
      assert Heap.mrg([tree], [tree_2]) |> hd() == tree
      assert Heap.mrg([tree_2], [tree]) |> hd() == tree
    end

    test "links the leading binomial trees from each heap if both trees are of the same rank" do
      tree = %{rank: 1, element: 1, children: []}
      tree_2 = %{rank: 1, element: 2, children: []}
      linked = Heap.link(tree, tree_2)
      assert Heap.mrg([tree], [tree_2]) == [linked]
    end
  end

  describe "merge/2" do
    test "immediately returns a suspension" do
      assert %Suspension{} = Heap.merge(Heap.empty(), Heap.empty())
    end

    test "shells out to mrg/2 implementation when forced" do
      heap = Suspension.create([%{rank: 1, element: 1, children: []}])
      assert Heap.merge(heap, Heap.empty()) |> Lazy.eval() == Suspension.force(heap)
      assert Heap.merge([], heap) |> Lazy.eval() == Suspension.force(heap)
    end
  end

  describe "delete_min/1" do
    test "immediately returns a suspension" do
      assert %Suspension{} = Heap.delete_min(Heap.empty())
    end

    test "removes the minimum tree in the heap when evaluated" do
      heap =
        Heap.empty()
        |> Heap.insert(2)
        |> Heap.insert(4)
        |> Heap.insert(3)

      assert {:ok, [%{children: [%{children: [], element: 4, rank: 0}], element: 3, rank: 1}]} ==
               Heap.delete_min(heap) |> Lazy.eval()
    end
  end
end
