defmodule UnbalancedSet do
  alias PFDS.Ordered
  alias PFDS.Chapter2

  defstruct set: :empty
  @type t() :: %__MODULE__{set: Chapter2.tree()}

  @doc """
  Creates a new empty UnbalancedSet
  """
  @spec new() :: t()
  def new(), do: %__MODULE__{}

  @doc """
  Creates an UnbalancedSet from a list
  """
  def from_list([]), do: %__MODULE__{}

  def from_list(list) do
    list
    |> Enum.reduce(%__MODULE__{}, fn x, acc ->
      optimized_insert(x, acc)
    end)
  end

  @spec member?(Chapter2.el(), __MODULE__.t()) :: bool()
  def member?(_, %__MODULE__{set: :empty}), do: false

  def member?(el, %__MODULE__{set: {left, root, right}}) do
    cond do
      Ordered.lt(el, root) -> member?(el, %UnbalancedSet{set: left})
      Ordered.lt(root, el) -> member?(el, %UnbalancedSet{set: right})
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
  @spec efficient_member(Chapter2.el(), __MODULE__.t()) :: bool()
  def efficient_member(el, %__MODULE__{set: tree}) do
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

  @spec insert(Chapter2.el(), __MODULE__.t()) :: __MODULE__.t()
  def insert(el, :empty), do: %__MODULE__{set: {:empty, el, :empty}}
  def insert(el, %__MODULE__{set: set}), do: %__MODULE__{set: insert_(el, set)}

  defp insert_(el, :empty), do: {:empty, el, :empty}

  defp insert_(el, {left, root, right} = tree) do
    cond do
      Ordered.lt(el, root) -> {insert_(el, left), root, right}
      Ordered.lt(root, el) -> {left, root, insert_(el, right)}
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
  def efficient_insert(el, %__MODULE__{set: tree}) do
    try do
      {:ok, %UnbalancedSet{set: handle_efficient_insert(el, tree)}}
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
  @spec optimized_insert(Chapter2.el(), t()) :: t()
  def optimized_insert(el, %__MODULE__{set: tree}),
    do: %__MODULE__{set: optimized_insert_(el, nil, tree)}

  defp optimized_insert_(el, el, :empty), do: raise(ExistingElementException, el)
  defp optimized_insert_(el, _prev, :empty), do: {:empty, el, :empty}

  defp optimized_insert_(el, previous, {left, root, right}) when el < root do
    {optimized_insert_(el, previous, left), root, right}
  end

  defp optimized_insert_(el, _, {left, root, right}) do
    {left, root, optimized_insert_(el, root, right)}
  end
end

defimpl Enumerable, for: UnbalancedSet do
  @impl true
  def reduce(_set, {:halt, acc}, _fun), do: {:halted, acc}
  def reduce(set, {:suspend, acc}, fun), do: {:suspended, acc, &reduce(set, &1, fun)}
  def reduce(%UnbalancedSet{set: :empty}, {:cont, acc}, _fun), do: {:done, acc}

  def reduce(%UnbalancedSet{set: set}, {:cont, acc}, fun) do
    {:done, reduce_(set, acc, fun)}
  end

  defp reduce_(:empty, acc, _fun), do: acc

  defp reduce_({left, root, right}, acc, fun) do
    with {:cont, intermediate} <- fun.(acc, root) do
      {:cont, sum} = fun.(reduce_(left, acc, fun), reduce_(right, acc, fun))
      {:cont, res} = fun.(intermediate, sum)
      res
    else
      {:halt, acc} -> acc
    end
  end

  @impl true
  def count(_), do: {:error, __MODULE__}

  @impl true
  def member?(set, el), do: {:ok, UnbalancedSet.efficient_member(el, set)}

  @impl true
  def slice(_set), do: {:error, __MODULE__}
end
