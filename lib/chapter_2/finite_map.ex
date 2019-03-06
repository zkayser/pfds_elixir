defmodule FiniteMap do
  @type key(key_type) :: key_type
  @type value(value_type) :: value_type
  @type map(value) :: :empty | {map(value), value, map(value)}

  @spec empty() :: map(any())
  def empty(), do: :empty

  @spec bind(key(any()), value(any()), map(any())) :: map(any())
  def bind(_key, _value, map) do
    map
  end

  @spec lookup(key(any()), map(any())) :: any()
  def lookup(_key, map) do
    map
  end
end
