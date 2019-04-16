defmodule BatchedQueue do
  @moduledoc """
  This module provides an implementation for fifo queues
  using strict evaluation. The amortized running times of
  the operations are good provided that the data structure
  is not used persistently.

  Elements get added to the queue on the rear list of a tuple
  of lists: `{front, rear}`, and elements are removed from
  the front list. The elements of the queue must therefore
  migrate from one list to the other, which is accomplished
  in this implementation by reversing the `rear` list and
  setting the result of the reversal as the new `front`
  whenever the `front` list would otherwise become empty,
  while simultaneously setting the new `rear` list to be empty.

  The goal is to maintain the invariant that `front` is empty
  only when `rear` is also empty (i.e., the entire queue is empty).
  By maintaining this invariant, we guarantee that `head` can always
  find the first element in O(1) time.
  """

  @type t(a) :: Queue.t(a)

  @doc """
  Creates an empty queue.
  """
  @spec empty() :: t(any)
  def empty(), do: {[], []}

  @doc """
  Returns true if the queue is empty
  """
  @spec empty?(t(any)) :: boolean
  def empty?({[], _}), do: true
  def empty?(_), do: false

  @doc """
  Takes a queue and returns the first element wrapped in an
  ok tuple or returns an error tuple if the queue is empty.
  """
  @spec head(t(any)) :: {:ok, any} | {:error, :empty_queue}
  def head({[head | _], _}), do: {:ok, head}
  def head({[], _}), do: {:error, :empty_queue}

  @doc """
  Removes the first element of the queue provided the queue
  is non-empty. Returns an error tuple otherwise.

  `tail/1` must detect cases that would result in a violation
  of the invariant that `front` is only empty when `rear` is
  also empty.
  """
  @spec tail(t(any)) :: {:ok, any} | {:error, :empty_queue}
  def tail({[_ | tail], rear}), do: {:ok, check_front({tail, rear})}
  def tail({[], _}), do: {:error, :empty_queue}

  @doc """
  Places an element onto the front of the rear list.

  List `tail/1`, `snoc/2` must also detect any cases that would
  result in a violation of the invariant that `front`is only empty
  when `rear` is also empty.
  """
  @spec snoc(t(any), any) :: t(any)
  def snoc({front, rear}, element), do: {front, [element | rear]} |> check_front()

  # Maintains the invariant that `front` only be empty when
  # `rear` is also empty.
  defp check_front({[], rear}), do: {Enum.reverse(rear), []}
  defp check_front(queue), do: queue
end
