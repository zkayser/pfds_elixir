defmodule PairingHeapTest do
  use ExUnit.Case

  describe "singleton/1" do
    test "creates a pairing heap with a single element and no children" do
      assert PairingHeap.singleton(1) == %PairingHeap{root: 1, children: []}
    end
  end
end
