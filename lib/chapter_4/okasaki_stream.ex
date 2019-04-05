defmodule OkasakiStream do
  defmodule Cons do
    @type t(a) :: %Cons{head: a, tail: OkasakiStream.t(a)}
    defstruct [:head, :tail]
  end

  @type cell(a) :: :empty | Cons.t(a)
  @type t(a) :: Suspension.t(cell(a))

  @spec append(t(any), t(any)) :: t(any)
  def append(stream_1, stream_2) do
    case Suspension.force(stream_1) do
      :empty ->
        stream_2

      %Cons{head: el, tail: tail} ->
        Suspension.create(%Cons{head: el, tail: append(tail, stream_2)})
    end
  end

  @spec take(t(any), non_neg_integer) :: t(any)
  def take(_stream, 0), do: Suspension.create(:empty)
  def take(stream, n) do
    case Suspension.force(stream) do
      :empty ->
        stream

      _ -> stream
    end
  end
end
