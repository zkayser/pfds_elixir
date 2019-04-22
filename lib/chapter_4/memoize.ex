defmodule Memoize do
  @moduledoc """
  A simple ETS-based memoization implementation for retrieving the
  results of Suspensions.
  """

  @table :memoization

  @doc """
  Retrieve a memoized value or apply the function, memoizing and
  returning the result
  """
  def get(mod, fun, args) do
    case lookup(mod, fun, args) do
      nil -> memoize_apply(mod, fun, args)
      {_, result} -> result
    end
  end

  defp lookup(mod, fun, args) do
    case :ets.lookup(@table, [mod, fun, args]) do
      [result | _] -> result
      [] -> nil
    end
  end

  defp memoize_apply(mod, fun, args) do
    result = apply(mod, fun, args)
    :ets.insert(@table, {[mod, fun, args], result})
    result
  end
end
