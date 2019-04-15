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
end
