defmodule OkasakiStream do
  # import Lazy

  defmodule Cons do
    @type t(a) :: %Cons{head: a, tail: OkasakiStream.t(a)}
    defstruct [:head, :tail]
  end

  @type cell(a) :: :empty | Cons.t(a)
  @type t(a) :: Suspension.t(cell(a))

  @doc """
  Converts a list into a stream
  """
  @spec from_list(list(any)) :: t(any)
  def from_list([]), do: Suspension.create(:empty)

  def from_list(list) do
    Enum.reduce(:lists.reverse(list), Suspension.create(:empty), fn el, acc ->
      append(suspend(el, empty()), acc)
    end)
  end

  @doc """
  Appends two stream together.
  """
  @spec append(t(any), t(any)) :: t(any)
  def append(stream_1, stream_2) do
    case Suspension.force(stream_1) do
      :empty ->
        stream_2

      %Cons{head: el, tail: tail} ->
        suspend(el, append(tail, stream_2))
    end
  end

  @doc """
  Takes a stream and a non-negative integer and returns a stream
  with `n` populated elements, or as many elements as are available
  in the stream.
  """
  @spec take(t(any), non_neg_integer) :: t(any)
  def take(_stream, 0), do: empty()

  def take(stream, n) do
    case Suspension.force(stream) do
      :empty ->
        stream

      %Cons{head: head, tail: tail} ->
        suspend(head, take(tail, n - 1))
    end
  end

  # deflazy ltake(stream, 0) do
  #   empty()
  # end

  # deflazy ltake(stream, n) do
  #   case stream do
  #     :empty ->
  #       stream

  #     %Cons{head: head, tail: tail} ->
  #       suspend(head, take(tail, n - 1))
  #   end
  # end

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
  @spec reverse(t(any)) :: Suspension.t(t(any))
  def reverse(stream) do
    Suspension.create(__MODULE__, :reverse, [stream, empty()])
  end

  # deflazy reverse(stream) do
  #   reverse(stream, empty())
  # end

  # def reverse(stream, reversed) do
  #   case Suspension.force(stream) do
  #     :empty -> reversed
  #     %Cons{head: head, tail: tail} -> reverse(tail, Suspension.create(Kernel, :struct [[head: head, tail: reversed]]))
  #   end
  # end

  @spec reverse(t(any), t(any)) :: t(any)
  def reverse(suspension, stream) do
    case Suspension.force(suspension) do
      :empty ->
        stream

      %Cons{head: head, tail: tail} ->
        reverse(tail, suspend(head, stream))
    end
  end

  # helper for suspending the creation of a Cons struct
  defp suspend(el, tail) do
    Suspension.create(Kernel, :struct, [Cons, [head: el, tail: tail]])
  end

  # helper for creating an empty stream
  def empty(), do: Suspension.create(:empty)
end
