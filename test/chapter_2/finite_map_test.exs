defmodule FiniteMapTest do
  use ExUnit.Case
  @key "my_key"
  @value "my_value"

  describe "empty/1" do
    test "creates an empty map" do
      assert :empty = FiniteMap.empty()
    end
  end

  describe "bind/3" do
    test "inserts the key and value at the root of an empty map" do
      assert {:empty, {key, value}, :empty} = FiniteMap.bind(FiniteMap.empty(), @key, @value)
      assert key == @key
      assert value == @value
    end

    test "inserts the key and value in the left map when key is less than the root key" do
      map =
        FiniteMap.empty()
        |> FiniteMap.bind(@key, @value)
        |> FiniteMap.bind("a", "value_2")

      assert {left, {@key, @value}, _right} = map
      assert {:empty, {"a", "value_2"}, :empty} = left
    end
  end

  describe "lookup/2" do
    test "returns the value for the associated key when the key is present in the map" do
      assert @value ==
               FiniteMap.empty()
               |> FiniteMap.bind(@key, @value)
               |> FiniteMap.lookup(@key)
    end

    test "raises a NotFoundException if the key is not present in the map" do
      assert_raise(FiniteMap.NotFoundException, fn ->
        FiniteMap.lookup(FiniteMap.empty(), @key)
      end)
    end
  end
end
