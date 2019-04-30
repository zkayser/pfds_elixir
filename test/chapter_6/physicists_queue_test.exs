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
end
