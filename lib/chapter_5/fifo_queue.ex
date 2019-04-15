defmodule FifoQueue do
  @moduledoc """
  This module provides an implementation for fifo queues
  using strict evaluation. The amortized running times of
  the operations are good provided that the data structure
  is not used persistently.
  """

  @type t(a) :: Queue.t(a)

  @spec head(t(any)) :: {:ok, any} | {:error, :empty_queue}
  def head({[head|_], _}), do: {:ok, head}
  def head({[], _}), do: {:error, :empty_queue}
end
