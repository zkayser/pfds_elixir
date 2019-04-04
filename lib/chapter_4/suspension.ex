defmodule Suspension do

  @type t(a) :: (() -> a)

  defstruct fun: nil

  def suspend(expression), do: %Suspension{fun: fn -> expression end}

  def force(%Suspension{fun: susp}) do
    susp.()
  end
end
