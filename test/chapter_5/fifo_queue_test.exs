defmodule FifoQueueTest do
  alias FifoQueue, as: Queue
  use ExUnit.Case

  describe "head/1" do
    test "returns the first element when the queue is not empty" do
      assert {:ok, 1} = Queue.head({[1], []})
    end

    test "returns an error tuple when the queue is empty" do
      assert {:error, :empty_queue} = Queue.head({[], []})
    end
  end
end
