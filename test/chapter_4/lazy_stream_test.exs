defmodule LazyStreamTest do
  use ExUnit.Case
  alias LazyStream, as: Stream
  alias LazyStream.Cons

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
      assert Suspension.force(stream) == Stream.drop(stream, 0) |> Lazy.eval()
    end

    test "returns the stream as is when the stream is empty" do
      stream = Suspension.create(:empty)
      assert Suspension.force(stream) == Stream.drop(stream, 10) |> Lazy.eval()
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
                  tail:
                    Suspension.create(%Cons{
                      head: 4,
                      tail: Suspension.create(:empty)
                    })
                })
            })
        })

      expected =
        Suspension.create(%Cons{
          head: 3,
          tail: Suspension.create(%Cons{head: 4, tail: Suspension.create(:empty)})
        })

      expected_2 = Suspension.create(%Cons{head: 4, tail: Suspension.create(:empty)})

      assert expected == Stream.drop(stream, 2) |> Lazy.eval()
      assert expected_2 == Stream.drop(stream, 3) |> Lazy.eval()
    end
  end

  describe "reverse/1" do
    test "performs a no-op on an empty stream" do
      stream = Suspension.create(:empty)
      assert stream == Stream.reverse(stream) |> Suspension.force()
    end

    test "reverses the order of a stream" do
      stream = Stream.from_list(for x <- 1..5, do: x)

      assert stream
             |> Stream.reverse()
             |> Lazy.eval()
             |> Stream.to_list()
             |> Lazy.eval() ==
               Stream.from_list(for x <- 5..1, do: x)
               |> Stream.to_list()
               |> Lazy.eval()
    end
  end

  describe "from_list/1" do
    test "turns a list into a stream" do
      stream = Stream.from_list([1, 2, 3])

      assert %Cons{head: 1, tail: tail} = Suspension.force(stream)
      assert %Cons{head: 2, tail: tail} = Suspension.force(tail)
      assert %Cons{head: 3, tail: tail} = Suspension.force(tail)
      assert :empty == Suspension.force(tail)
    end
  end

  describe "to_list" do
    test "turns a stream into a list" do
      stream = Stream.from_list([1, 2, 3])

      assert Lazy.eval(Stream.to_list(stream)) == [1, 2, 3]
    end
  end
end
