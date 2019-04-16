defmodule SplayHeapTest do
  use ExUnit.Case

  describe "singleton/1" do
    test "creates a SplayHeap with a single element" do
      assert SplayHeap.singleton(1) == %SplayHeap{el: 1}
    end
  end
end
