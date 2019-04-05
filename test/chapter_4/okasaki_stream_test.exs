defmodule OkasakiStreamTest do
  use ExUnit.Case
  alias OkasakiStream, as: Stream
  alias OkasakiStream.Cons

  describe "append/2" do
    test "returns the non-empty stream when given one empty and one non-empty stream" do
      stream_1 = Suspension.create(:empty)
      stream_2 = Suspension.create(%Cons{head: 1, tail: Suspension.create(:empty)})

      assert %{head: head} = Suspension.force(Stream.append(stream_1, stream_2))
      assert head == 1
    end

    test "places the second stream as the tail of the first stream" do
      stream_1 = Suspension.create(%Cons{head: 1, tail: Suspension.create(:empty)})
      stream_2 = Suspension.create(%Cons{head: 2, tail: Suspension.create(:empty)})

      assert %{head: head, tail: tail} = Suspension.force(Stream.append(stream_1, stream_2))
      assert %{head: next, tail: last} = Suspension.force(tail)
      assert :empty = Suspension.force(last)
      assert head == 1
      assert next == 2
    end
  end
end
