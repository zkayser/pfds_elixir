range = 1..1_000_000

Benchee.run(%{
  "red_black_tree" => fn ->
    range
    |> Enum.reduce(RedBlackTree.empty(), fn x, rb_tree ->
      RedBlackTree.insert(rb_tree, x)
    end)
  end
})
