range = 1..1_000_000
tree = Enum.reduce(range, :empty, fn x, acc ->
        RedBlackTree.insert(acc, x)
      end)


Benchee.run(%{
  "red_black_tree" => fn ->
    tree
    |> RedBlackTree.insert(2000000)
  end
}, [parallel: 1])
