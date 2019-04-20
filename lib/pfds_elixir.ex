defmodule PfdsElixir do
  use Application

  def start(_type, _args) do
    :ets.new(:memoization, [:public, :named_table])
    {:ok, self()}
  end
end
