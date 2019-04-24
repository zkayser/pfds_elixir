defmodule LazyBinomialHeap do
  @typep tree(a) :: %{rank: non_neg_integer(), element: a, children: list(tree(a))}
  @type t(a) :: Suspension.t(list(tree(a)))

  @doc """
  Initializes an empty heap
  """
  @spec empty() :: t(any)
  def empty, do: Suspension.create([])

  @doc """
  Returns true if the heap is empty
  """
  @spec empty?(t(any)) :: boolean
  def empty?(heap) do
    case Suspension.force(heap) do
      [] -> true
      _ -> false
    end
  end
end
