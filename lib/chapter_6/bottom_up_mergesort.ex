defmodule BottomUpMergeSort do
  @moduledoc """
  #---------------------------------------------------------------------------

  This implementation of mergesort uses a `Sortable` collection that provides
  amortized bounds of O(log n) for the `add` operation and O(n) for `sort`.

  `Sortable` collections in this implementation are represented by a suspended
  list of segments, each of which is a list of elements, along with an integer
  representing the total size of the collection.

  #---------------------------------------------------------------------------
  """
  @typedoc """
  Represents a sortable collection
  """
  defstruct [:size, :segments]

  @type t(a) :: %__MODULE__{
          size: non_neg_integer,
          segments: Suspension.t(list(list(a)))
        }

  @doc """
  Initializes a sortable collection
  """
  @spec init() :: t(any)
  def init(), do: %__MODULE__{size: 0, segments: Suspension.create([])}

  @doc """
  Merges two ordered lists together.
  """
  @spec mrg(list(any), list(any)) :: list(any)
  def mrg([], list), do: list
  def mrg(list, []), do: list
  def mrg([x | xs_], [y | _] = ys) when x <= y, do: [x | mrg(xs_, ys)]
  def mrg(xs, [y | ys_]), do: [y | mrg(xs, ys_)]
end
