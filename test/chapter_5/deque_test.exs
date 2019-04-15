defmodule DequeTest do
  use ExUnit.Case

  describe "empty/0" do
    test "creates an empty deque" do
      assert Deque.empty == {[], []}
    end
  end
end
