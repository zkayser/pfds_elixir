defmodule Heap do
  alias __MODULE__
  alias PFDS.Ordered

  defstruct node: :empty,
            left: :empty,
            right: :empty,
            rank: 0

  @type t(elem) :: %Heap{node: :empty | elem,
                         left: :empty | t(elem),
                         right: :empty | t(elem),
                         rank: non_neg_integer()
                        }
  @type elem :: any()

  @spec empty() :: t(elem)
  def empty, do: %Heap{}

  @spec is_empty?(t(elem)) :: bool()
  def is_empty?(%Heap{node: :empty}), do: true
  def is_empty?(_), do: false

  @spec insert(t(elem), elem) :: t(elem)
  def insert(heap, _elem), do: heap

  @spec merge(t(elem), t(elem)) :: t(elem)
  def merge(heap_1, %Heap{node: :empty}), do: heap_1
  def merge(%Heap{node: :empty}, heap_2), do: heap_2
  def merge(heap_1, :empty), do: heap_1
  def merge(:empty, heap_2), do: heap_2
  def merge(%Heap{node: x, left: left_1, right: right_1} = h1, %Heap{node: y, left: left_2, right: right_2} = h2) do
    case Ordered.leq(x, y) do
      true -> make_heap(x, left_1, merge(right_1, h2))
      false -> make_heap(y, left_2, merge(h1, right_2))
    end
  end

  defp make_heap(value, h1, h2) do
    case rank(h1) >= rank(h2) do
      true -> %Heap{rank: rank(h2) + 1, node: value, left: h2, right: h1}
      _ -> %Heap{rank: rank(h1) + 1, node: value, left: h1, right: h2}
    end
  end

  defp rank(:empty), do: 0
  defp rank(%Heap{rank: rank}), do: rank

  @spec find_min(t(elem)) :: elem
  def find_min(heap), do: heap.node

  @spec delete_min(t(elem)) :: t(elem)
  def delete_min(heap), do: heap
end
