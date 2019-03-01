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

    @type el() :: term()
    @opaque tree() :: :empty | {tree, el, tree}
    @type set() :: tree

    @spec member?(el, tree()) :: bool()
    def member?(_, :empty), do: false
    def member?(el, {left, root, right}) do
      cond do
        Ordered.lt(el, root) -> member?(el, left)
        Ordered.lt(root, el) -> member?(el, right)
        true -> true
      end
    end

    @doc """
    In the worst case, `member?/2` will performly approximately `2d` comparisons where `d` is
    the depth of the tree. The implementation is simpler, but we can do better.

    `efficient_member/2` tracks a candidate element that might be equal to the query element: the candidate
    element will either be `nil` or the last element for which the `<` comparison would be false. If the
    query element is less than the node currently being compared, we dive into the left subtree, otherwise
    we go right. When we hit the bottom of the tree, `:empty`, if the query element is equal to the candidate
    element, then the query element is a member of `tree` and we return `true`.

    In terms of run time performance, `efficient_member/2` performs no more than `d + 1` comparisons, making
    it significantly more performant than the naive implementation of `member?/2` above while maintaining its
    behavior.
    """
    @spec efficient_member(el, tree()) :: bool()
    def efficient_member(el, tree) do
      case tree do
        :empty -> false
        {left, root, _} when el < root -> handle_member(el, left, nil)
        {_, root, right} -> handle_member(el, right, root)
      end
    end

    defp handle_member(el, :empty, candidate), do: el == candidate
    defp handle_member(el, {left, root, _}, candidate) when el < root, do: handle_member(el, left, candidate)
    defp handle_member(el, {_, root, right}, _), do: handle_member(el, right, root)

    @spec insert(el, tree) :: tree()
    def insert(el, :empty), do: {:empty, el, :empty}
    def insert(el, {left, root, right} = tree) do
      cond do
        Ordered.lt(el, root) -> {insert(el, left), root, right}
        Ordered.lt(root, el) -> {left, root, insert(el, right)}
        true -> tree
      end
    end
  end
end
