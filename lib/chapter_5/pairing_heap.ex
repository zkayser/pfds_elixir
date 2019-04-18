defmodule PairingHeap do
  @moduledoc """

  #----------------------------------------------------------
  Pairing heaps are heap-ordered multi-way trees.

  In terms of running time of the operations available on
  pairing heaps, `find_min/1`, `insert/2`, and `merge/2`
  all run in O(1) worst-case time; however, `delete_min/1`
  can run in O(n) time in the worst case.

  In analogy to Splay Trees, however, `insert/1`, `merge/2`,
  and `delete_min/1` can all run in O(log n) amortized time.

  Pairing heaps are nearly as fast Splay Heaps for applications
  that do not use the `merge` function, and much faster for
  applications that do. Like splay heaps, however, they should
  be used only for applications that do not take advantage of
  persistence.
  #----------------------------------------------------------
  """

  defstruct root: nil, children: []
  @type t(a) :: :empty | %PairingHeap{root: a, children: list(t(a))}

  @doc """
  Creates a pairing heap with a single element
  and no children.
  """
  @spec singleton(any) :: t(any)
  def singleton(el), do: %PairingHeap{root: el}
end
