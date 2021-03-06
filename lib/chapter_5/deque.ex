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
  @behaviour Queue
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

  @doc """
  Returns the first element in the deque if the deque is
  non-empty; otherwise returns an error tuple
  """
  @spec head(t(any)) :: {:ok, any} | {:error, :empty_queue}
  def head({[el | _], _}), do: {:ok, el}
  def head({[], [only_element]}), do: {:ok, only_element}
  def head({[], []}), do: {:error, :empty_queue}

  @doc """
  Removes the first element from the deque if the deque
  is non-empty; otherwise returns an error tuple
  """
  @spec tail(t(any)) :: {:ok, t(any)} | {:error, :empty_queue}
  def tail({[_ | front_tail], rear}), do: {:ok, maintain_invariant({front_tail, rear})}
  def tail({[], [_ | _] = rear}), do: {:ok, maintain_invariant({[], rear})}
  def tail({[], []}), do: {:error, :empty_queue}

  @doc """
  Places an element at the rear of the deque.

  `snoc/2` must also maintain the invariant for
  deques that both the `front` and `rear` lists
  be non-empty when there are at least two elements
  in the deque.
  """
  @spec snoc(t(any), any) :: t(any)
  def snoc({front, rear}, el) do
    {front, [el | rear]}
    |> maintain_invariant()
  end

  @doc """
  Returns the last element of the deque.
  """
  @spec last(t(any)) :: {:ok, any} | {:error, :empty_queue}
  def last({_, [last | _]}), do: {:ok, last}
  def last({[only_element], []}), do: {:ok, only_element}
  def last({[], []}), do: {:error, :empty_queue}

  @doc """
  Removes the last element of the deque if the deque
  is non-empty; otherwise returns an error tuple
  """
  @spec init(t(any)) :: {:ok, t(any)} | {:error, :empty_queue}
  def init({front, [_ | rear_tail]}), do: {:ok, maintain_invariant({front, rear_tail})}
  def init({[_ | _] = front, []}), do: {:ok, maintain_invariant({front, []})}
  def init({[], []}), do: {:error, :empty_queue}

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

    {new_front, :lists.reverse(new_rear)}
  end

  defp maintain_invariant({[], rear}) do
    {new_rear, new_front} =
      rear
      |> Enum.split(floor(length(rear) / 2))

    {:lists.reverse(new_front), new_rear}
  end

  defp maintain_invariant(deque), do: deque
end
