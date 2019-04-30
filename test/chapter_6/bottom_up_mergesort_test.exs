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
end
