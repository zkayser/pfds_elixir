defmodule SplayHeap do
  @moduledoc """
  Splay trees are closely related to balanced binary search trees, but they contain
  no explicit balance information. They are known as one of the most successful amortized
  data structures.

  Instead of explicitly maintaining balances the way balanced binary search trees do,
  splay trees blindly restructure the tree using simple transformations that tend to
  increase balance.

  Although any operation can run in O(n) worst-case time, every operation runs in
  O(log n) amortized time.

  Splay trees make an excellent implementation for heaps because the only interesting
  query on heaps is `find_min/1` -- splay trees are slightly awkward when used with
  abstractions that tend to be query-heavy since splay trees are restructured not
  only during updates, but also on queries.

  Splay trees in combination with the `ExplicitMin` abstraction are the fastest known
  implementation of heaps for most applications that do not depend on persistence
  _AND_ that do not call the `merge/2` function.
  """
  defstruct left: :empty,
            el: nil,
            right: :empty

  @type t(a) :: :empty | %SplayHeap{left: t(a), el: a, right: t(a)}

  @doc """
  Creates a SplayHeap with a single element.
  """
  @spec singleton(any) :: t(any)
  def singleton(el) do
    %SplayHeap{el: el}
  end
end
