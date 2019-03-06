defmodule FiniteMap do
  @moduledoc """
  Accomplishes Exercise 2.6
  --> Adapt the `UnbalancedSet` functor to support finite maps rather than sets.
  """

  @type map(key, value) :: :empty | {map(key, value), {key, value}, map(key, value)}
  @typep key :: any()
  @typep value :: any()

  defmodule NotFoundException do
    defexception [:message]

    @impl true
    def exception(element) do
      %NotFoundException{
        message: "Key #{inspect(element, pretty: true)} not found"
      }
    end
  end

  @spec empty() :: map(key, value)
  def empty(), do: :empty

  @spec bind(map(key, value), key, value) :: map(key, value)
  def bind(:empty, key, value) do
    {:empty, {key, value}, :empty}
  end

  def bind(map, key, value) do
    bind_(map, key, value)
  end

  defp bind_(:empty, key, value), do: {:empty, {key, value}, :empty}

  defp bind_({left, {prev_key, _} = entry, right}, key, value) when key <= prev_key do
    {bind_(left, key, value), entry, right}
  end

  defp bind_({left, entry, right}, key, value) do
    {left, entry, bind_(right, key, value)}
  end

  @spec lookup(map(key, value), key) :: value | none()
  def lookup(:empty, _), do: raise(NotFoundException)
  def lookup({_, {key, value}, _}, key), do: value

  def lookup({left, {current_key, _}, _}, key) when key < current_key do
    lookup(left, key)
  end

  def lookup({_, _, right}, key) do
    lookup(right, key)
  end
end
