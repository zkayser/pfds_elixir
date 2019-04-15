defmodule DequeTest do
  use ExUnit.Case

  describe "empty/0" do
    test "creates an empty deque" do
      assert Deque.empty == {[], []}
    end
  end

  describe "empty?/1" do
    test "returns true if the deque is empty" do
      assert Deque.empty?(Deque.empty)
    end

    test "returns false when the deque is non-empty" do
      refute Deque.empty?({[1], []})
    end
  end
end
