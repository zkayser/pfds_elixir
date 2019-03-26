defmodule ExplicitMinTest do
  use ExUnit.Case

  describe "init/1" do
    test "creates an explicit min heap with valid implementations" do
      assert %{impl: LeftistHeap} = ExplicitMin.init(LeftistHeap)
      assert %{impl: WeightBiasedLeftistHeap} = ExplicitMin.init(WeightBiasedLeftistHeap)
      assert %{impl: BinomialHeap} = ExplicitMin.init(BinomialHeap)
      assert %{impl: RanklessBinomialHeap} = ExplicitMin.init(RanklessBinomialHeap)
    end

    test "raises an ArgumentError if called with an invalid heap implementation" do
      assert_raise ArgumentError, fn ->
        ExplicitMin.init(InvalidHeap)
      end
    end
  end

  describe "insert/2" do
    test "keeps track of minimum value while inserting" do
      heap =
        ExplicitMin.insert(ExplicitMin.init(BinomialHeap), 5)
        |> ExplicitMin.insert(10)
        |> ExplicitMin.insert(1)
        |> ExplicitMin.insert(50)

      assert heap.minimum == 1
    end
  end

  describe "merge/2" do
    test "takes the minimum value of both heaps when merging" do
      heap_1 = ExplicitMin.insert(ExplicitMin.init(BinomialHeap), 20)
      heap_2 = ExplicitMin.insert(ExplicitMin.init(BinomialHeap), 10)

      assert ExplicitMin.merge(heap_1, heap_2).minimum == 10
    end
  end

  describe "delete_min/1" do
    test "removes the minimum node and replaces the underlying heap with a new heap" do
      heap =
        ExplicitMin.insert(ExplicitMin.init(BinomialHeap), 10)
        |> ExplicitMin.insert(20)
        |> ExplicitMin.insert(1)

      assert {:ok, new_explicit_min} = ExplicitMin.delete_min(heap)
      assert new_explicit_min.minimum == 10
    end
  end
end
