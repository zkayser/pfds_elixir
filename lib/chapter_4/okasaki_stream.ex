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
        Suspension.create(%Cons{head: el, tail: append(tail, stream_2)})
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
        Suspension.create(%Cons{head: head, tail: take(tail, n - 1)})
    end
  end
end
