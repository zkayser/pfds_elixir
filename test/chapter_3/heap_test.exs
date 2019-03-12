defmodule HeapTest do
  use ExUnit.Case

  describe "empty/0" do
    test "creates an empty heap" do
      assert %Heap{node: :empty, left: :empty, right: :empty} == Heap.empty()
    end
  end
end
