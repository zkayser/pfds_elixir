defmodule PFDS.Chapter2 do
  @type el() :: term()
  @opaque tree() :: :empty | {tree, el, tree}


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
    alias PFDS.Chapter2

    @spec member?(Chapter2.el, Chapter2.tree()) :: bool()
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
    @spec efficient_member(Chapter2.el, Chapter2.tree()) :: bool()
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

    @spec insert(Chapter2.el, Chapter2.tree()) :: Chapter2.tree()
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
    @spec efficient_insert(Chapter2.el, Chapter2.tree()) :: {:ok, Chapter2.tree()} | {:existing_element, Chapter2.tree()}
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
    @spec optimized_insert(Chapter2.el, Chapter2.tree()) :: Chapter2.tree()
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

  @doc """
  Exercise 2.5 A)
  Sharing can be also be useful within a single object, not just between objects. For example,
  if the two subtrees of a given node are identical, then they can be represented by the same tree.

  a) Using this idea, write a function `complete` of type `Elem -> Int -> Tree` where `complete(x, d)`
  creates a binary tree of depth `d` with `x` stored in every node. (Of course, this function makes no
  sense for the set abstraction, but it can be a useful auxilary function for other abstractions, such
  as bags.) This function should run in `O(d)` time.
  """
  @spec complete(el, non_neg_integer()) :: tree()
  def complete(_x, 0), do: :empty
  def complete(x, d) do
    sub_tree = complete(x, d - 1)
    { sub_tree, x, sub_tree }
  end

  @doc """
  Exercise 2.5 B)

  Extend the above `complete` function to create balanced trees of arbitrary size. These trees will
  not always be complete binary trees, but should be as balanced as possible: for any given node,
  the two subtrees should differ in size by at most one. This function should run in `O(log n)` time.
  """
  def balanced(_x, 0), do: :empty
  def balanced(x, size) do
    {sub_tree_1, sub_tree_2} = create_2(x, div(size - 1, 2))
    case rem(size, 2) == 0 do
      true -> { sub_tree_1, x, sub_tree_2 }
      false -> { sub_tree_1, x, sub_tree_1 }
    end
  end

  defp create_2(_x, size) when size < 0, do: {:empty, :empty}
  defp create_2(x, 0), do: {:empty, {:empty, x, :empty}}
  defp create_2(x, size) when rem(size, 2) != 0 do
    { sub_tree_1, sub_tree_2 } = create_2(x, div(size - 1, 2))
    { { sub_tree_1, x, sub_tree_1}, { sub_tree_1, x, sub_tree_2 } }
  end
  defp create_2(x, size) do
    { sub_tree_1, sub_tree_2 } = create_2(x, div(size - 2, 2))
    { {sub_tree_1, x, sub_tree_2}, {sub_tree_2, x, sub_tree_2} }
  end
end
