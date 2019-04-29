defmodule LazyStream do
  @moduledoc """
  A stream module exposing lazy functions.

  With the exception of `from_list/1` and `to_list/1`,
  the functions declared in this module instantly
  return unevaluated `Suspension`s and defer their
  evaluations until forced with `Lazy.eval/0`.
  """

  import Lazy

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
      append(%Cons{head: el, tail: Suspension.create(:empty)}, acc)
    end)
  end

  @doc """
  Converts a stream into a list
  """
  def to_list(stream) do
    to_list_(stream, [])
  end

  defp to_list_(stream, acc) do
    case Suspension.force(stream) do
      :empty -> :lists.reverse(acc)
      %Cons{head: el, tail: tail} -> to_list_(tail, [el | acc])
    end
  end

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

  @doc """
  Drops the first n values of the stream.
  """
  @spec drop(t(any), non_neg_integer) :: t(any)
  deflazy drop(stream, n) do
    drop_(stream, n)
  end

  defp drop_(stream, 0), do: stream

  defp drop_(:empty, _), do: :empty

  defp drop_(%Cons{tail: tail}, n) do
    drop_(tail, n - 1)
  end

  defp drop_(stream, n) do
    case Suspension.force(stream) do
      :empty ->
        :empty

      %Cons{tail: tail} ->
        drop_(tail, n - 1)
    end
  end

  @doc """
  Reverses a stream
  """
  @spec reverse(t(any)) :: Suspension.t(t(any))
  deflazy reverse(stream) do
    reverse_(stream, Suspension.create(:empty))
  end

  defp reverse_(:empty, reversed), do: reversed

  defp reverse_(%Cons{head: head, tail: tail}, reversed),
    do: reverse_(Suspension.create(Kernel, :struct, [Cons, [head: head, tail: reversed]]), tail)

  defp reverse_(reversed, stream), do: reverse_(Suspension.force(stream), reversed)
end
