defmodule SuspensionTest do
  use ExUnit.Case

  describe "suspend/1" do
    test "wraps a value inside of a function" do
      fun = Suspension.suspend(5) |> Map.get(:fun)
      assert fun.() == 5
    end
  end

  describe "force/1" do
    test "calls the suspended function" do
      assert 5 == Suspension.suspend(5) |> Suspension.force()
    end
  end
end
