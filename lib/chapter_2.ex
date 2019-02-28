defmodule PFDS.Chapter2 do
  @spec suffixes(list(any())) :: list(list(any()))
  def suffixes(list) do
    do_suffixes(list, [])
  end

  defp do_suffixes([], acc), do: acc ++ [[]]

  defp do_suffixes([_ | tail] = list, acc) do
    do_suffixes(tail, acc ++ [list])
  end

  defmodule UnbalancedSet do
    alias PFDS.Ordered

    @type elem :: term
    @type tree :: :empty | {tree, elem, tree}
    @type set :: tree

    @spec member(elem, tree()) :: bool()
    def member(_, :empty), do: false
    def member(el, {left, root, right}) do
      cond do
        Ordered.lt(el, root) -> member(el, left)
        Ordered.lt(root, el) -> member(el, right)
        true -> true
      end
    end
  end

  @spec insert(elem, tree) :: tree()
  def insert(el, :empty), do: {:empty, el, :empty}
  def insert(el, {left, root, right} = tree) do
    cond do
      Ordered.lt(el, root) -> {insert(el, left), root, right}
      Ordered.lt(root, el) -> {left, root, insert(el, right)}
      true -> tree
    end
  end
end
