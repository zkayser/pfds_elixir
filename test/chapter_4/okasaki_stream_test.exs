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

  describe "take/2" do
    test "returns an empty suspension when take 0 is passed" do
      assert :empty == Stream.take(Suspension.create(1), 0) |> Suspension.force()
    end

    test "returns an empty suspension when called with any n on an empty stream" do
      assert :empty == Stream.take(Suspension.create(:empty), 5) |> Suspension.force()
    end

    test "returns a stream with n elements if the stream is larger than n" do
      stream =
        Suspension.create(%Cons{
          head: 1,
          tail:
            Suspension.create(%Cons{
              head: 2,
              tail:
                Suspension.create(%Cons{
                  head: 3,
                  tail: Suspension.create(:empty)
                })
            })
        })

      result = Stream.take(stream, 2)
      assert %{head: head, tail: tail} = Suspension.force(result)
      assert %{head: next, tail: last} = Suspension.force(tail)
      assert :empty = Suspension.force(last)
      assert head == 1
      assert next == 2
    end

    test "returns a stream with up to n elements when n is larger than the stream" do
      stream = Suspension.create(%Cons{head: 1, tail: Suspension.create(:empty)})
      assert %{head: head, tail: last} = Stream.take(stream, 7) |> Suspension.force()
      assert :empty = Suspension.force(last)
      assert head == 1
    end
  end

  describe "drop/2" do
    test "returns the stream as is when 0 is passed for _n_" do
      stream = Suspension.create(%Cons{head: 1, tail: Suspension.create(:empty)})
      assert stream == Stream.drop(stream, 0)
    end

    test "returns the stream as is when the stream is empty" do
      stream = Suspension.create(:empty)
      assert stream == Stream.drop(stream, 10)
    end

    test "returns the stream with the first _n_ elements dropped" do
      stream =
        Suspension.create(%Cons{
          head: 1,
          tail:
            Suspension.create(%Cons{
              head: 2,
              tail:
                Suspension.create(%Cons{
                  head: 3,
                  tail: Suspension.create(:empty)
                })
            })
        })

      expected = Suspension.create(%Cons{head: 3, tail: Suspension.create(:empty)})
      assert expected == Stream.drop(stream, 2)
    end
  end
end
