defmodule BatchedQueueTest do
  alias BatchedQueue, as: Queue
  use ExUnit.Case

  describe "empty/0" do
    test "returns an empty queue" do
      assert Queue.empty() == {[], []}
    end
  end

  describe "empty?/1" do
    test "returns true if the queue is empty" do
      assert Queue.empty?(Queue.empty())
    end

    test "returns false when the queue is non-empty" do
      refute Queue.empty?({[1], []})
    end
  end

  describe "head/1" do
    test "returns the first element when the queue is not empty" do
      assert {:ok, 1} = Queue.head({[1], []})
    end

    test "returns an error tuple when the queue is empty" do
      assert {:error, :empty_queue} = Queue.head({[], []})
    end
  end

  describe "tail/1" do
    test "removes the first element when the queue is non-empty" do
      assert {:ok, {[2], []}} = Queue.tail({[1, 2], []})
    end

    test "returns an error tuple when the queue is empty" do
      assert {:error, :empty_queue} = Queue.tail({[], []})
    end

    test "detects violations of the batched queue invariant" do
      assert {:ok, {[2, 3, 4], []}} = Queue.tail({[1], [4, 3, 2]})
    end
  end

  describe "snoc/2" do
    test "places an element onto the front of the rear list" do
      assert {[1], [2]} = Queue.snoc({[1], []}, 2)
    end

    test "handles cases that would violate the batched queue invariant" do
      assert {[1], []} = Queue.snoc({[], []}, 1)
    end
  end
end
