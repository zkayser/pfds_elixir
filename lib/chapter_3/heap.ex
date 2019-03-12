defmodule Heap do

  defstruct node: :empty,
            left: :empty,
            right: :empty

  @type t(elem) :: %__MODULE__{node: :empty | t(elem),
                         left: :empty | t(elem),
                         right: :empty | t(elem)
                        }

  @spec empty() :: t(any())
  def empty, do: %__MODULE__{}

  @spec is_empty?(t(any())) :: bool()
  def is_empty?(%__MODULE__{node: :empty}), do: true
  def is_empty?(_), do: false
end
