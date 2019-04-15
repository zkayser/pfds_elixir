defmodule BatchedQueue do
  @moduledoc """
  This module provides an implementation for fifo queues
  using strict evaluation. The amortized running times of
  the operations are good provided that the data structure
  is not used persistently.
  """

  @type t(a) :: Queue.t(a)

  @doc """
  Takes a queue and returns the first element wrapped in an
  ok tuple or returns an error tuple if the queue is empty.
  """
  @spec head(t(any)) :: {:ok, any} | {:error, :empty_queue}
  def head({[head|_], _}), do: {:ok, head}
  def head({[], _}), do: {:error, :empty_queue}

  @doc """
  Removes the first element of the queue provided the queue
  is non-empty. Returns an error tuple otherwise.
  """
  @spec tail(t(any)) :: {:ok, any} | {:error, :empty_queue}
  def tail({[_|tail], rear}), do: {:ok, {tail, rear}}
  def tail({[], _}), do: {:error, :empty_queue}

  @doc """
  Places an element onto the front of the rear list.
  """
  @spec snoc(t(any), any) :: t(any)
  def snoc({front, rear}, element), do: {front, [element|rear]}
end
