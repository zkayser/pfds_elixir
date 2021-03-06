defmodule Heap do
  @opaque heap(a) ::
            LeftistHeap.t(a)
            | WeightBiasedLeftistHeap.t(a)
            | BinomialHeap.heap(a)
            | RanklessBinomialHeap.heap(a)
            | PairingHeap.t(a)
            | ExplicitMin.explicit_min(a)

  @callback empty() :: heap(any)
  @callback insert(heap(any), any) :: heap(any)
  @callback merge(heap(any), heap(any)) :: heap(any)
  @callback find_min(heap(any)) :: {:ok, any} | {:error, :empty_heap}
  @callback delete_min(heap(any)) :: {:ok, heap(any)} | {:error, :empty_heap}
end
