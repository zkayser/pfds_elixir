defmodule WeightBiasedLeftistHeap do
  alias __MODULE__, as: WBLeftistHeap

  @moduledoc """

  ################
  # Exercise 3.4 #
  ################

  # -------------------------------------------------------------
  Problem Description: Weight-biased leftist heaps are an
  alternative to leftist heaps that replace the leftist property
  with the _weight-biased leftist property_: the size of any left
  child is at least as large as the size of its right sibling.

  (a) Prove that the right spine of a weight-biased leftist heap
      contains at most |log(n + 1)| elements.
  (b) Modify the implementation [of `LeftistHeap`] to obtain
      weight-biased leftist heaps.
  (c) Currently, `merge` operates in two passes: a top-down pass
      consisting of calls to `merge`, and a bottom-up pass
      consisting of calls to the helper function `makeT` (NOTE:
      the aforementioned implementation is from the Standard ML
      example from the book). Modify `merge` for weight-biased
      leftist heaps to operate in a single, top-down pass.
  (d) What advantages would the top-down version of `merge`
      have in a lazy environment? In a concurrent environment?
  # -------------------------------------------------------------
  """

  defstruct rank: 1,
            element: nil,
            left: :empty,
            right: :empty

  @type t(a) ::
          :empty
          | %WBLeftistHeap{
              rank: pos_integer(),
              left: t(a),
              right: t(a)
            }

  @spec empty() :: t(any)
  def empty(), do: :empty

  @spec is_empty?(t(any)) :: boolean()
  def is_empty?(:empty), do: true
  def is_empty?(%WBLeftistHeap{}), do: false

  @spec singleton(any) :: t(any)
  def singleton(val), do: %WBLeftistHeap{element: val}

  @spec merge(t(any), t(any)) :: t(any)
  def merge(:empty, %WBLeftistHeap{} = heap), do: heap
  def merge(%WBLeftistHeap{} = heap, :empty), do: heap
  def merge(:empty, :empty), do: empty()

  def merge(%WBLeftistHeap{element: x} = h1, %WBLeftistHeap{element: y} = h2) when x > y do
    merge(h2, h1)
  end

  def merge(%WBLeftistHeap{right: right, left: left} = h1, %WBLeftistHeap{} = h2) do
    merged = merge(right, h2)
    {rank_left, rank_right} = {rank(left), rank(merged)}

    case rank_left >= rank_right do
      true -> %WBLeftistHeap{h1 | right: merged, rank: h1.rank + 1}
      false -> %WBLeftistHeap{h1 | left: merged, right: left, rank: h1.rank + 1}
    end
  end

  defp rank(:empty), do: 0
  defp rank(%WBLeftistHeap{rank: rank}), do: rank
end
