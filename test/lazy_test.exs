defmodule LazyTest do
  use ExUnit.Case

  defmodule TestModule do
    import Lazy

    deflazy add(a, b, c) do
      a + b + c
    end

    deflazy add(a, b) do
      a + b
    end

    deflazy identity(a) do
      a
    end
  end

  describe "deflazy/2" do
    test "returns a suspension" do
      assert %Suspension{} = susp = TestModule.identity(2)
      assert Suspension.force(susp) == 2

      assert %Suspension{} = susp_2 = TestModule.add(2, 4)
      assert Suspension.force(susp_2) == 6

      assert %Suspension{} = susp_3 = TestModule.add(2, 4, 6)
      assert Suspension.force(susp_3) == 12
    end

    test "evaluates suspended parameters when the resulting suspension is forced" do
      assert 2
             |> Suspension.create()
             |> TestModule.identity()
             |> Suspension.force() == 2
    end

    test "evaluates two and three basic suspended parameters when resulting suspension is forced" do
      one = Suspension.create(1)
      two = Suspension.create(2)
      three = Suspension.create(3)

      assert TestModule.add(one, two) |> Suspension.force() == 3
      assert TestModule.add(one, two, three) |> Suspension.force() == 6
    end
  end
end
