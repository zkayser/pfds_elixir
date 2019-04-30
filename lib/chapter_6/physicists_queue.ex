defmodule PhysicistsQueue do
  @moduledoc """

  #---------------------------------------------------------------------

  A persistent implementation of queues where every
  operation runs in O(1) amortized time. The `PhysicistsQueue`
  structure is analyzed using the Physicists method, which
  means that there is no reason to prefer incremental suspensions
  over monolithic suspensions (whereas the Bankers method _does_
  create incentives for preferring incremental suspensions).

  With that being the case, the representation of the PhysicistsQueue
  is slightly different, using suspended lists instead of streams, and
  not suspending the rear list at all.

  The lengths of both the front and rear list are tracked explicitly,
  as they are in other implementations, and we guarantee again that
  the front list is at least as long as the rear list.

  Since the front list is suspended, we cannot access its first element
  without executing the entire suspension. To get around this, the
  PhysicistsQueue also keeps a working copy of a prefix of the front
  list to respond to `head` queries. The working copy is represented
  as an ordinary list.

  #---------------------------------------------------------------------
  """
  defstruct [:working_copy, :length_f, :front, :length_r, :rear]

  @typedoc """
  Representation of the PhysicistsQueue
  """
  @type t(a) :: %PhysicistsQueue{
          working_copy: list(a),
          length_f: non_neg_integer,
          front: Suspension.t(list(a)),
          length_r: non_neg_integer,
          rear: list(a)
        }

  @doc """
  Initializes an empty queue.
  """
  @spec empty() :: t(any)
  def empty() do
    %PhysicistsQueue{
      working_copy: [],
      length_f: 0,
      front: Suspension.create([]),
      length_r: 0,
      rear: []
    }
  end

  @doc """
  Returns true for empty queues.
  """
  @spec empty?(t(any)) :: boolean
  def empty?(%PhysicistsQueue{length_f: 0}), do: true
  def empty?(_), do: false

  @doc """
  Adds an element to the queue.
  """
  @spec snoc(t(any), any) :: t(any)
  def snoc(queue, element),
    do:
      check(%PhysicistsQueue{queue | length_r: queue.length_r + 1, rear: [element | queue.rear]})

  @doc """
  Returns the front element in the queue wrapped in an
  ok tuple for non-empty queues. Otherwise returns an
  error tuple.
  """
  @spec head(t(any)) :: {:ok, any} | {:error, :empty}
  def head(%PhysicistsQueue{working_copy: []}), do: {:error, :empty}
  def head(%PhysicistsQueue{working_copy: [head | _]}), do: {:ok, head}

  defp check(%PhysicistsQueue{length_f: front, length_r: rear} = queue) when rear <= front,
    do: check_w(queue)

  defp check(%PhysicistsQueue{} = queue) do
    front_ = Suspension.force(queue.front)

    check_w(%PhysicistsQueue{
      working_copy: front_,
      length_f: queue.length_f + queue.length_r,
      front: Suspension.create(Kernel, :++, [front_, :lists.reverse(queue.rear)]),
      length_r: 0,
      rear: []
    })
  end

  defp check_w(%PhysicistsQueue{working_copy: [], front: front} = queue),
    do: %PhysicistsQueue{queue | working_copy: Suspension.force(front)}

  defp check_w(queue), do: queue
end
