defmodule PFDS.Chapter2Test do
  use ExUnit.Case
  import PFDS.Chapter2

  describe "suffixes/1" do
    test "returns a list of all the suffixes of xs in descending order of length" do
      assert suffixes([1, 2, 3, 4]) == [[1, 2, 3, 4], [2, 3, 4], [3, 4], [4], []]
    end
  end
end
