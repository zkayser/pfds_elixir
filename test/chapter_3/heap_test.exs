defmodule HeapTest do
  use ExUnit.Case

  describe "empty/0" do
    test "creates an empty heap" do
      assert %Heap{node: :empty, left: :empty, right: :empty} == Heap.empty()
    end
  end

  describe "is_empty?/1" do
    test "returns true if node is empty" do
      assert Heap.empty() |> Heap.is_empty?()
    end

    test "returns false if node contains a value" do
      refute %Heap{node: 1} |> Heap.is_empty?()
    end
  end
end
