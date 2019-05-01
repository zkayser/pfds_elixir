defmodule LazyPairingHeapTest do
  use ExUnit.Case
  alias LazyPairingHeap, as: Heap

  describe "empty/0" do
    test "initializes an empty pairing heap" do
      assert :empty = Heap.empty()
    end
  end
end
