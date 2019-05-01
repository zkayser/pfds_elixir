defmodule LazyPairingHeap do
  @moduledoc """
  #-----------------------------------------------------------------

  A lazy implementation of the PairingHeap data structure with
  bounds that are asymptotically as efficient in a persistent
  setting as the original implementation.

  In the original implementation, deleting the minimum element
  discards the root and merges its children in pairs using the
  `merge_pairs/2` function. In a persistent environment, if we
  deleted the minimum element of the same heap twice, then the
  `merge_pairs/2` function would be called twice, thereby duplicating
  work and destroying amortized efficiency.

  To circumvent this duplication of efforts in a persistent
  environment, we use lazy evaluation and memoization by
  changing the heap's representation of children elements from
  a list of heaps to suspended heaps: Suspension.t(heap).

  Because `merge_pairs/2` operates on pairs of children, we
  extend the suspension with two children at once and include
  an extra heap field in each node to hold any partnerless children.
  This field will be empty if the number of children is even.

  #-----------------------------------------------------------------
  """

  defstruct [:root, :single_child, :children]

  @type t(a) ::
          :empty
          | %__MODULE__{
              root: a,
              single_child: t(a),
              children: Suspension.t(t(a))
            }

  @doc """
  Initializes an empty pairing heap.
  """
  @spec empty :: t(any)
  def empty, do: :empty
end
