defmodule Suspension do

  @type t(a) :: %Suspension{fun: (() -> a)}
  @typep fun_expression :: {atom, atom, list(any)} | any

  defstruct fun: nil

  @spec create(fun_expression) :: t(any)
  def create({mod, fun, args}), do: %Suspension{fun: fn -> apply(mod, fun, args) end}
  def create(expression), do: %Suspension{fun: fn -> expression end}

  @spec force(t(any)) :: any
  def force(%Suspension{fun: susp}) do
    susp.()
  end
end
