defmodule Heap do
  @opaque heap(a) :: LeftistHeap.t(a) | WeightBiasedLeftistHeap.t(a) | [%{children: heap(a)}]

  @callback insert(any, heap(any)) :: heap(any)
  @callback merge(heap(any), heap(any)) :: heap(any)
  @callback find_min(heap(any)) :: {:ok, any} | {:error, :empty_heap}
  @callback delete_min(heap(any)) :: {:ok, heap(any)} | {:error, :empty_heap}
end
