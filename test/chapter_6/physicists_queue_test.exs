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

  describe "snoc/2" do
    test "adds an element onto the rear list when the rear list is smaller than the front list" do
      queue = %Queue{
        working_copy: [1],
        length_f: 1,
        front: Suspension.create([1]),
        length_r: 0,
        rear: []
      }

      result = Queue.snoc(queue, 2)
      assert result.rear == [2]
    end

    test "reverses the rear list and appends it to the front list when the rear list becomes larger than the front list" do
      queue = %Queue{
        working_copy: [1],
        length_f: 2,
        front: Suspension.create([1, 2]),
        length_r: 2,
        rear: [4, 3]
      }

      result = Queue.snoc(queue, 5)

      assert result == %Queue{
               working_copy: [1, 2],
               length_f: 5,
               front: Suspension.create(Kernel, :++, [[1, 2], :lists.reverse([5, 4, 3])]),
               length_r: 0,
               rear: []
             }
    end
  end
end
