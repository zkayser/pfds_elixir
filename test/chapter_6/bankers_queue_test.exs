defmodule BankersQueueTest do
  alias BankersQueue, as: Queue
  use ExUnit.Case

  describe "snoc/2" do
    test "appends an element to the queue" do
      queue =
        Queue.init()
        |> Queue.snoc(2)

      assert queue.front |> Suspension.force() |> Map.get(:head) == 2
    end
  end

  describe "head/1" do
    test "returns the head element from the queue" do
      queue = Queue.init() |> Queue.snoc(2)
      assert {:ok, 2} = Queue.head(queue)
    end

    test "returns an error tuple if the queue is empty" do
      assert {:error, :empty} = Queue.init() |> Queue.head()
    end
  end

  describe "tail/1" do
    test "removes the head element from the queue" do
      queue = Queue.init() |> Queue.snoc(1) |> Queue.snoc(2)

      assert {:ok, Queue.init() |> Queue.snoc(2)} == Queue.tail(queue)
    end

    test "returns an error tuple if the queue is empty" do
      assert {:error, :empty} = Queue.init() |> Queue.tail()
    end
  end
end
