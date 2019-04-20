defmodule PersistentQueue do
  @moduledoc """
  An efficient persistent implementation of queues
  in which every operation runs in O(1) amortized time.
  """
  alias OkasakiStream, as: Stream
  alias OkasakiStream.Cons, as: Cons

  defstruct length_f: 0, front: nil, length_r: 0, rear: nil

  @type t(a) :: %PersistentQueue{
          length_f: non_neg_integer,
          front: Stream.t(a),
          length_r: non_neg_integer,
          rear: Stream.t(a)
        }

  @doc """
  Initializes a queue
  """
  def init(),
    do: %PersistentQueue{front: Suspension.create(:empty), rear: Suspension.create(:empty)}

  @doc """
  Adds an element to the queue
  """
  @spec snoc(t(any), any) :: t(any)
  def snoc(%PersistentQueue{} = queue, el) do
    check(%PersistentQueue{
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
  def head(%PersistentQueue{length_f: 0}), do: {:error, :empty}

  def head(%PersistentQueue{front: front}) do
    case Suspension.force(front) do
      %Cons{head: head} -> {:ok, head}
      _ -> {:error, :empty}
    end
  end

  defp check(%PersistentQueue{length_f: lenf, length_r: lenr} = q) when lenr <= lenf, do: q

  defp check(queue) do
    %PersistentQueue{
      length_f: queue.length_f + queue.length_r,
      front: Stream.append(queue.front, Stream.reverse(queue.rear)),
      length_r: 0,
      rear: Suspension.create(:empty)
    }
  end
end
