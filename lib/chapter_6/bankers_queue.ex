defmodule BankersQueue do
  @moduledoc """
  An efficient persistent implementation of queues
  in which every operation runs in O(1) amortized time.
  """
  alias OkasakiStream, as: Stream
  alias OkasakiStream.Cons, as: Cons

  defstruct length_f: 0, front: nil, length_r: 0, rear: nil

  @type t(a) :: %BankersQueue{
          length_f: non_neg_integer,
          front: Stream.t(a),
          length_r: non_neg_integer,
          rear: Stream.t(a)
        }

  @doc """
  Initializes a queue
  """
  def init(),
    do: %BankersQueue{front: Suspension.create(:empty), rear: Suspension.create(:empty)}

  @doc """
  Adds an element to the queue
  """
  @spec snoc(t(any), any) :: t(any)
  def snoc(%BankersQueue{} = queue, el) do
    check(%BankersQueue{
      queue
      | length_r: queue.length_r + 1,
        rear: Suspension.create(%Cons{head: el, tail: queue.rear})
    })
  end

  @doc """
  Returns the head of the queue or an error
  tuple if the queue is empty.
  """
  @spec head(t(any)) :: {:ok, any} | {:error, :empty}
  def head(%BankersQueue{length_f: 0}), do: {:error, :empty}

  def head(%BankersQueue{front: front}) do
    case Suspension.force(front) do
      %Cons{head: head} -> {:ok, head}
      _ -> {:error, :empty}
    end
  end

  @doc """
  Removes the head of the queue or returns an error
  tuple if the queue is empty
  """
  def tail(%BankersQueue{length_f: 0}), do: {:error, :empty}

  def tail(%BankersQueue{front: front} = queue) do
    case Suspension.force(front) do
      %Cons{tail: tail} ->
        {:ok, check(%BankersQueue{queue | length_f: queue.length_f - 1, front: tail})}

      :empty ->
        {:error, :empty}
    end
  end

  defp check(%BankersQueue{length_f: lenf, length_r: lenr} = q) when lenr <= lenf, do: q

  defp check(queue) do
    %BankersQueue{
      length_f: queue.length_f + queue.length_r,
      front: Stream.append(queue.front, Suspension.force(Stream.reverse(queue.rear))),
      length_r: 0,
      rear: Suspension.create(:empty)
    }
  end
end
