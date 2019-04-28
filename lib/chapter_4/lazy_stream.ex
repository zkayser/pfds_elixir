defmodule LazyStream do
  import Lazy

  defmodule Cons do
    @type t(a) :: %Cons{head: a, tail: OkasakiStream.t(a)}
    defstruct [:head, :tail]
  end

  @type cell(a) :: :empty | Cons.t(a)
  @type t(a) :: Suspension.t(cell(a))

  @doc """
  Appends two streams together, immediately
  returning a suspension.
  """
  @spec append(t(any), t(any)) :: t(any)
  deflazy append(stream_1, stream_2) do
    case stream_1 do
      :empty ->
        stream_2

      %Cons{head: head, tail: tail} ->
        %Cons{head: head, tail: append(stream_2, tail)}
    end
  end

  @doc """
  Takes a stream and a non-negative integer and returns a stream
  with `n` populated elements, or as many elements as are available
  in the stream.
  """
  @spec take(t(any), non_neg_integer) :: t(any)
  deflazy take(_stream, 0) do
    :empty
  end

  deflazy take(stream, n) do
    case stream do
      :empty ->
        :empty

      %Cons{head: head, tail: tail} ->
        %Cons{head: head, tail: take(tail, n - 1)}
    end
  end
end
