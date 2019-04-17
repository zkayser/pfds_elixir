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

  @doc """
  Inserts an element into the heap. The element being
  inserted should be placed at the root of the heap
  with the rest of the heap being partitioned into
  elements that are larger than the element being
  inserted stored in the right heap and elements
  smaller than the element being inserted stored in
  the left heap.
  """
  @spec insert(t(any), any) :: t(any)
  def insert(heap, el) do
    {smaller, bigger} = partition(heap, el)

    %SplayHeap{
      left: smaller,
      el: el,
      right: bigger
    }
  end

  @doc """
  Finds and returns the smallest element contained
  in the heap.
  """
  @spec find_min(t(any)) :: any
  def find_min(%SplayHeap{left: :empty, el: min}), do: min
  def find_min(%SplayHeap{left: left}), do: find_min(left)

  @doc """
  Removes the minimum node from the heap and restructures the
  heap at the same time to keep the heap balanced.
  """
  @spec delete_min(t(any)) :: t(any)
  def delete_min(%SplayHeap{left: :empty, right: right}), do: right
  def delete_min(%SplayHeap{left: %SplayHeap{left: :empty, right: min_sibling}, el: y, right: right}) do
    %SplayHeap{left: min_sibling, el: y, right: right}
  end
  def delete_min(%SplayHeap{left: %SplayHeap{left: a, el: x, right: b}, el: y, right: right}) do
    %SplayHeap{left: delete_min(a), el: x, right: %SplayHeap{left: b, el: y, right: right}}
  end

  defp partition(:empty, _), do: {:empty, :empty}

  defp partition(%SplayHeap{left: l, el: x, right: r} = heap, el) when x <= el do
    case r do
      :empty ->
        {heap, :empty}

      %SplayHeap{el: y} = sub_heap when y <= el ->
        {smaller, bigger} = partition(sub_heap.right, el)

        {%SplayHeap{
           left: %SplayHeap{left: l, el: x, right: sub_heap.left},
           el: y,
           right: smaller
         }, bigger}

      %SplayHeap{el: y} = sub_heap ->
        {smaller, bigger} = partition(sub_heap.left, el)

        {%SplayHeap{left: l, el: x, right: smaller},
         %SplayHeap{left: bigger, el: y, right: sub_heap.right}}
    end
  end

  defp partition(%SplayHeap{left: l, el: x, right: r} = heap, el) do
    case l do
      :empty ->
        {:empty, heap}

      %SplayHeap{el: y} = sub_heap when y <= el ->
        {smaller, bigger} = partition(sub_heap.right, el)

        {%SplayHeap{left: sub_heap.left, el: y, right: smaller},
         %SplayHeap{left: bigger, el: x, right: r}}

      %SplayHeap{el: y} = sub_heap ->
        {smaller, bigger} = partition(sub_heap.left, el)

        {smaller,
         %SplayHeap{left: bigger, el: y, right: %SplayHeap{left: sub_heap.right, el: x, right: r}}}
    end
  end
end
