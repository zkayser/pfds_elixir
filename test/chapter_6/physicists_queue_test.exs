defmodule PhysicistsQueueTest do
  use ExUnit.Case
  alias PhysicistsQueue, as: Queue

  describe "empty/0" do
    test "creates an empty queue" do
      assert Queue.empty() == %Queue{
               working_copy: [],
               length_f: 0,
               front: Suspension.create([]),
               length_r: 0,
               rear: []
             }
    end
  end

  describe "empty?/1" do
    test "returns true for empty queues" do
      assert Queue.empty?(Queue.empty())
    end

    test "returns false if the queue is not empty" do
      refute Queue.empty?(%Queue{
               working_copy: [1],
               length_f: 1,
               front: Suspension.create([1]),
               length_r: 0,
               rear: []
             })
    end
  end
end
