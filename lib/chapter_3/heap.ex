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
end
