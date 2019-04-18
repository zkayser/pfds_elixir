defmodule ExplicitMin do
  @behaviour Heap
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
  @valid_heap_impls [LeftistHeap, WeightBiasedLeftistHeap, BinomialHeap, RanklessBinomialHeap, PairingHeap]
  @typep implementation ::
           LeftistHeap | WeightBiasedLeftistHeap | BinomialHeap | RanklessBinomialHeap | PairingHeap
  @type explicit_min(a) :: %{minimum: a | :empty, heap: Heap.heap(a), impl: implementation}

  @doc """
  Inits a new explicit min heap with a specific implementation
  """
  @spec init(implementation) :: explicit_min(any)
  def init(implementation) when implementation in @valid_heap_impls do
    %{minimum: :empty, heap: implementation.empty(), impl: implementation}
  end

  def init(invalid) do
    raise %ArgumentError{
      message: """
      Cannot call ExplicitMin.init with implementation #{inspect(invalid)}.\n
      Please use one of the valid heap implementations: #{
        inspect(@valid_heap_impls, pretty: true)
      }
      """
    }
  end

  @impl true
  @spec empty() :: explicit_min(any)
  def empty(), do: init(LeftistHeap)

  @impl true
  @spec insert(explicit_min(any), any) :: explicit_min(any)
  def insert(%{minimum: min, heap: heap, impl: impl} = explicit_min, val)
      when val < min or min == :empty do
    %{explicit_min | minimum: val, heap: impl.insert(heap, val)}
  end

  def insert(%{heap: heap, impl: impl} = explicit_min, val) do
    %{explicit_min | heap: impl.insert(heap, val)}
  end

  @impl true
  @spec merge(explicit_min(any), explicit_min(any)) :: explicit_min(any)
  def merge(%{minimum: :empty}, explicit_min), do: explicit_min
  def merge(explicit_min, %{minimum: :empty}), do: explicit_min

  def merge(
        %{minimum: min_1, heap: heap_1, impl: impl} = em_1,
        %{minimum: min_2, heap: heap_2} = em_2
      ) do
    case min_1 < min_2 do
      true -> %{em_1 | heap: impl.merge(heap_1, heap_2)}
      false -> %{em_2 | heap: impl.merge(heap_1, heap_2)}
    end
  end

  @impl true
  @spec find_min(explicit_min(any)) :: {:ok, any} | {:error, :empty_heap}
  def find_min(%{minimum: :empty}), do: {:error, :empty_heap}
  def find_min(%{minimum: min}), do: {:ok, min}

  @impl true
  @spec delete_min(explicit_min(any)) :: {:ok, explicit_min(any)} | {:error, :empty_heap}
  def delete_min(%{minimum: :empty}), do: {:error, :empty_heap}

  def delete_min(%{heap: heap, impl: impl} = explicit_min) do
    with {:ok, new_heap} <- impl.delete_min(heap),
         {:ok, new_min} <- impl.find_min(new_heap) do
      {:ok, %{explicit_min | minimum: new_min, heap: new_heap}}
    else
      error -> error
    end
  end
end
