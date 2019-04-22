defmodule OkasakiStream do
  defmodule Cons do
    @type t(a) :: %Cons{head: a, tail: OkasakiStream.t(a)}
    defstruct [:head, :tail]
  end

  @type cell(a) :: :empty | Cons.t(a)
  @type t(a) :: Suspension.t(cell(a))

  @doc """
  Appends two stream together.
  """
  @spec append(t(any), t(any)) :: t(any)
  def append(stream_1, stream_2) do
    case Suspension.force(stream_1) do
      :empty ->
        stream_2

      %Cons{head: el, tail: tail} ->
        Suspension.create(Kernel, :struct, [Cons, [head: el, tail: append(tail, stream_2)]])
    end
  end

  @doc """
  Takes a stream and a non-negative integer and returns a stream
  with `n` populated elements, or as many elements as are available
  in the stream.
  """
  @spec take(t(any), non_neg_integer) :: t(any)
  def take(_stream, 0), do: Suspension.create(:empty)

  def take(stream, n) do
    case Suspension.force(stream) do
      :empty ->
        stream

      %Cons{head: head, tail: tail} ->
        Suspension.create(Kernel, :struct, [Cons, [head: head, tail: take(tail, n - 1)]])
    end
  end

  @doc """
  Drops the first n values of the stream.
  """
  @spec drop(t(any), non_neg_integer) :: t(any)
  def drop(stream, 0), do: stream

  def drop(stream, n) do
    case Suspension.force(stream) do
      :empty ->
        stream

      %Cons{tail: tail} ->
        drop(tail, n - 1)
    end
  end

  @doc """
  Reverses a stream
  """
  def reverse(stream), do: reverse_(stream, Suspension.create(:empty))

  defp reverse_(suspension, stream) do
    case Suspension.force(suspension) do
      :empty ->
        stream

      %Cons{head: head, tail: tail} ->
        reverse_(tail, Suspension.create(Kernel, :struct, [Cons, [head: head, tail: stream]]))
    end
  end
end
