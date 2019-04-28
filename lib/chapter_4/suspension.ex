defmodule Suspension do
  @type t(a) :: %Suspension{fun: (() -> a)}
  @typep fun_expression :: {atom, atom, list(any)} | any
  @typep mod :: atom
  @typep func :: atom
  @typep args :: list(any)

  defstruct fun: nil

  @spec create(mod, func, args) :: t(any)
  def create(mod, fun, args) do
    %Suspension{
      fun: fn ->
        Memoize.get(mod, fun, args)
      end
    }
  end

  @spec create(fun_expression) :: t(any)
  def create({mod, fun, args}) do
    %Suspension{
      fun: fn ->
        Memoize.get(mod, fun, args)
      end
    }
  end

  def create(expression) do
    %Suspension{
      fun: fn ->
        expression
      end
    }
  end

  @spec force(t(any)) :: any
  def force(%Suspension{fun: susp}) do
    susp.()
  end

  def force(val), do: val
end
