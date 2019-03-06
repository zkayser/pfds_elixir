defmodule UnbalancedSet do
  alias PFDS.Ordered
  alias PFDS.Chapter2

  @spec member?(Chapter2.el(), Chapter2.tree()) :: bool()
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
  @spec efficient_member(Chapter2.el(), Chapter2.tree()) :: bool()
  def efficient_member(el, tree) do
    case tree do
      :empty -> false
      {left, root, _} when el < root -> handle_member(el, left, nil)
      {_, root, right} -> handle_member(el, right, root)
    end
  end

  defp handle_member(el, :empty, candidate), do: el == candidate

  defp handle_member(el, {left, root, _}, candidate) when el < root,
    do: handle_member(el, left, candidate)

  defp handle_member(el, {_, root, right}, _), do: handle_member(el, right, root)

  @spec insert(Chapter2.el(), Chapter2.tree()) :: Chapter2.tree()
  def insert(el, :empty), do: {:empty, el, :empty}

  def insert(el, {left, root, right} = tree) do
    cond do
      Ordered.lt(el, root) -> {insert(el, left), root, right}
      Ordered.lt(root, el) -> {left, root, insert(el, right)}
      true -> tree
    end
  end

  defmodule ExistingElementException do
    defexception [:message]

    @impl true
    def exception(element) do
      %ExistingElementException{
        message: "Element #{inspect(element, pretty: true)} already exists"
      }
    end
  end

  @doc """
  Exercise 2.3
  Inserting an existing element into a binary search tree copies the entire search path even though the
  copied nodes are indistinguishable from the originals. Rewrite `insert` using exceptions to avoid this copying.
  Establish one handler per insertion rather than per iteration.
  """
  @spec efficient_insert(Chapter2.el(), Chapter2.tree()) ::
          {:ok, Chapter2.tree()} | {:existing_element, Chapter2.tree()}
  def efficient_insert(el, tree) do
    try do
      {:ok, handle_efficient_insert(el, tree)}
    rescue
      ExistingElementException -> {:existing_element, tree}
    end
  end

  defp handle_efficient_insert(el, :empty), do: {:empty, el, :empty}

  defp handle_efficient_insert(el, {_, root, _}) when el == root do
    raise(ExistingElementException, el)
  end

  defp handle_efficient_insert(el, {left, root, right}) do
    case Ordered.lt(el, root) do
      true -> {handle_efficient_insert(el, left), root, right}
      false -> {left, root, handle_efficient_insert(el, right)}
    end
  end

  @doc """
  Exercise 2.4
  Combine the ideas of the previous two exercises to obtain a version
  of insert that performs no unnecessary copying and uses no more than
  d + 1 comparisons
  """
  @spec optimized_insert(Chapter2.el(), Chapter2.tree()) :: Chapter2.tree()
  def optimized_insert(el, tree), do: optimized_insert_(el, nil, tree)
  defp optimized_insert_(el, el, :empty), do: raise(ExistingElementException, el)
  defp optimized_insert_(el, _prev, :empty), do: {:empty, el, :empty}

  defp optimized_insert_(el, previous, {left, root, right}) when el < root do
    {optimized_insert_(el, previous, left), root, right}
  end

  defp optimized_insert_(el, _, {left, root, right}) do
    {left, root, optimized_insert_(el, root, right)}
  end
end
