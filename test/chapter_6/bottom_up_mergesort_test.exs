defmodule BottomUpMergeSortTest do
  use ExUnit.Case
  alias BottomUpMergeSort, as: Sortable

  describe "init/0" do
    test "initializes a Sortable collection" do
      assert Sortable.init() == %Sortable{size: 0, segments: Suspension.create([])}
    end
  end

  describe "mrg/2" do
    test "returns the non-empty list of when given one empty and one non-empty list" do
      non_empty = [2]
      assert Sortable.mrg([], non_empty) == non_empty
      assert Sortable.mrg(non_empty, []) == non_empty
    end

    test "merges two ordered lists together" do
      first = [1, 3, 5]
      second = [2, 4, 6]

      assert Sortable.mrg(first, second) == [1, 2, 3, 4, 5, 6]
    end
  end

  describe "add/2" do
    test "adds an element into the collection" do
      segments = Sortable.init() |> Sortable.add(1) |> Map.get(:segments) |> Suspension.force()

      assert segments == [[1]]

      new_segments =
        Sortable.add(%Sortable{segments: Suspension.create(segments), size: 1}, 7)
        |> Sortable.add(4)
        |> Sortable.add(5)
        |> Map.get(:segments)
        |> Suspension.force()

      Enum.reduce(:lists.flatten(new_segments), 0, fn x, acc ->
        assert acc <= x
        x
      end)
    end

    test "increments the size property on the collection" do
      collection = Sortable.init()
      assert collection.size == 0

      new_collection = Sortable.add(collection, 1)
      assert new_collection.size == 1
    end
  end
end
