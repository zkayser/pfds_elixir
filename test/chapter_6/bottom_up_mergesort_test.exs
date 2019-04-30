defmodule BottomUpMergeSortTest do
  use ExUnit.Case
  alias BottomUpMergeSort, as: Sortable

  describe "init/0" do
    test "initializes a Sortable collection" do
      assert Sortable.init() == %Sortable{size: 0, segments: Suspension.create([])}
    end
  end
end
