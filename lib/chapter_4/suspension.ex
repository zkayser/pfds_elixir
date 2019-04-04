defmodule Suspension do

  @type t(a) :: (() -> a)

  defstruct fun: nil

  def create({mod, fun, args}), do: %Suspension{fun: fn -> apply(mod, fun, args) end}
  def create(expression), do: %Suspension{fun: fn -> expression end}

  def force(%Suspension{fun: susp}) do
    susp.()
  end
end
