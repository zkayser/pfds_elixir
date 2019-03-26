defprotocol ExplicitMin do
  @moduledoc """
  #-------------------------------------------------------
  ################
  # Exercise 3.7 #
  ################

  Problem Description: One clear advantage of leftist heaps
  over binomial heaps is the `find_min` takes only O(1) time,
  rather than O(log n) time. The following functor skeleton
  improves the running time of `find_min` to O(1) by
  storing the minimum element separately from the rest of
  the heap.

    ```
    functor ExplicitMin (H: Heap): Heap =
    struct
      structure Elem = H.Elem
      datatype Heap = E | NE of Elem.T x H.Heap
    ```

  Note that this functor is not specific to binomial heaps,
  but rather takes any implementation of heaps as a parameter.
  Complete this functor so that `find_min` takes O(1) time,
  and `insert`, `merge`, and `delete_min` take O(log n)
  time (assuming that all four take O(log n) time or better
  for the underlying implementation, `H`).
  #-------------------------------------------------------
  """
  @typep implementation :: LeftistHeap | WeightBiasedLeftistHeap | BinomialHeap | RanklessBinomialHeap
  @type explicit_min(a) :: %{minimum: a | :empty, heap: Heap.heap(a), impl: implementation}

  @spec insert(any, explicit_min(any)) :: explicit_min(any)
  def insert(val, heap)

  @spec merge(explicit_min(any), explicit_min(any)) :: explicit_min(any)
  def merge(heap_1, heap_2)

  @spec find_min(explicit_min(any)) :: {:ok, any} | {:error, :empty_heap}
  def find_min(heap)

  @spec delete_min(explicit_min(any)) :: {:ok, explicit_min(any)} | {:error, :empty_heap}
  def delete_min(heap)
end
