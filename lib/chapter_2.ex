defmodule PFDS.Chapter2 do
  @spec suffixes(list(any())) :: list(list(any()))
  def suffixes(list) do
    do_suffixes(list, [])
  end

  defp do_suffixes([], acc), do: acc ++ [[]]

  defp do_suffixes([_ | tail] = list, acc) do
    do_suffixes(tail, acc ++ [list])
  end
end
