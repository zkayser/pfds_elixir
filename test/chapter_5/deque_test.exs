defmodule DequeTest do
  use ExUnit.Case

  describe "empty/0" do
    test "creates an empty deque" do
      assert Deque.empty() == {[], []}
    end
  end

  describe "empty?/1" do
    test "returns true if the deque is empty" do
      assert Deque.empty?(Deque.empty())
    end

    test "returns false when the deque is non-empty" do
      refute Deque.empty?({[1], []})
    end
  end

  describe "cons/2" do
    test "places an element on the front of the deque" do
      assert Deque.cons(Deque.empty(), 1) == {[1], []}
    end

    test "maintains the deque invariant that both front and rear lists be non-empty with 2+ elements" do
      assert Deque.empty()
             |> Deque.cons(1)
             |> Deque.cons(2) == {[2], [1]}
    end
  end

  describe "head/1" do
    test "returns the first element in the deque when non-empty" do
      assert {:ok, 1} = Deque.head({[1], []})
      assert {:ok, 1} = Deque.head({[], [1]})
    end

    test "returns an error tuple when the deque is empty" do
      assert {:error, :empty_queue} = Deque.head(Deque.empty())
    end
  end

  describe "tail/1" do
    test "removes the first element from the deque" do
      assert Deque.tail({[1], []}) == {:ok, Deque.empty()}
      assert Deque.tail({[1], [2]}) == {:ok, {[2], []}}
      assert Deque.tail({[1, 2], [3]}) == {:ok, {[2], [3]}}
    end

    test "returns an error tuple when the deque is empty" do
      assert {:error, :empty_queue} = Deque.tail(Deque.empty())
    end
  end

  describe "snoc/2" do
    test "places an element at the back of the deque" do
      assert Deque.snoc({[1], [2]}, 3) == {[1], [3, 2]}
    end

    test "maintains the invariant that both lists must be non-empty when there are 2+ elements in the deque" do
      assert Deque.empty()
             |> Deque.snoc(1)
             |> Deque.snoc(2) == {[1], [2]}
    end
  end

  describe "last/1" do
    test "returns the last element in the deque when non-empty" do
      assert {:ok, 2} = Deque.last({[1], [2]})
      assert {:ok, 2} = Deque.last({[2], []})
    end

    test "returns an error tuple when the deque is empty" do
      assert {:error, :empty_queue} = Deque.last(Deque.empty())
    end
  end

  describe "init/1" do
    test "removes the last element of the deque" do
      assert {:ok, {[1], []}} = Deque.init({[1], [2]})
      assert {:ok, {[1], [2]}} = Deque.init({[1], [3, 2]})
      assert {:ok, Deque.empty()} == Deque.init({[], [1]})
    end

    test "returns an error tuple when the deque is empty" do
      assert {:error, :empty_queue} = Deque.init(Deque.empty())
    end
  end
end
