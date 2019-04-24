range = 1..1_000_000

Benchee.run(%{
  "red_black_tree" => fn ->
    range
    |> Enum.reduce(RedBlackTree.empty(), fn x, rb_tree ->
      RedBlackTree.insert(rb_tree, x)
    end)
  end,
  "bankers_queue" => fn ->
    range = 1..1_000

    queue =
      Enum.reduce(range, BankersQueue.init(), fn element, q ->
        BankersQueue.snoc(q, element)
      end)

    Enum.reduce(range, queue, fn _, q ->
      case BankersQueue.tail(q) do
        {:ok, tail} -> tail
        _ -> q
      end
    end)
  end
})
