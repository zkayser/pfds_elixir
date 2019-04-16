defmodule Deque do
  @moduledoc """

  ################
  # Exercise 5.1 #
  ################

  #-------------------------------------------------------------

  Expand on the BatchedQueue design to support the
  _double-ended queue_ or _deque_ abstraction, which
  allows reads and writes to both ends of the queue.
  The batched queue invariant is updated to be symmetric
  in its treatment of both `front` and `rear` lists: both
  are required to be non-empty whenever the deque contains
  two or more elements. When one list becomes empty, we
  split the other list in half and reverse one of the halves.

  #-------------------------------------------------------------
  """

  @type t(a) :: Queue.t(a)

  @doc """
  Creates an empty deque
  """
  @spec empty() :: t(any)
  def empty(), do: {[], []}

  @doc """
  Returns true when the deque is empty
  """
  @spec empty?(t(any)) :: boolean
  def empty?({[], _}), do: true
  def empty?(_), do: false

  @doc """
  Places an element on the front of the deque.

  `cons` must also maintain the deque invariant
  that both the `front` and `rear` lists be non-empty
  whenever the queue contains two or more elements.
  """
  @spec cons(t(any), any) :: t(any)
  def cons({front, rear}, el) do
    {[el | front], rear}
    |> maintain_invariant()
  end

  # Maintains the invariant that both the `front`
  # and `rear` lists must be non-empty whenever the
  # queue contains two or more elements. This function
  # splits the non-empty list in half and reverses one
  # of the halves when one becomes empty.
  defp maintain_invariant({[], []} = deque), do: deque
  defp maintain_invariant({[_], []} = deque), do: deque

  defp maintain_invariant({front, []}) do
    {new_front, new_rear} =
      front
      |> Enum.split(round(length(front) / 2))

    {new_front, Enum.reverse(new_rear)}
  end

  defp maintain_invariant({[], rear}) do
    {new_rear, new_front} =
      rear
      |> Enum.split(floor(length(rear) / 2))

    {Enum.reverse(new_front), new_rear}
  end
end
