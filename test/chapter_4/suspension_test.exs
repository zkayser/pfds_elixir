defmodule SuspensionTest do
  use ExUnit.Case

  describe "create/1" do
    test "wraps a value inside of a function" do
      fun = Suspension.create(5) |> Map.get(:fun)
      assert fun.() == 5
    end

    test "creates a suspension from tuples with mod, fun, args" do
      fun = Suspension.create({Kernel, :+, [1, 2]}) |> Map.get(:fun)
      assert fun.() == 3
    end
  end

  describe "force/1" do
    test "calls the suspended function" do
      assert 5 == Suspension.create(5) |> Suspension.force()
      assert 5 == Suspension.create({Kernel, :+, [2, 3]}) |> Suspension.force()
    end
  end
end
