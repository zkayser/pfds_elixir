defmodule Lazy do
  defmacro deflazy(head, body) do
    {_, args_ast} = name_and_args(head)
    args = get_args(args_ast)

    ast = Macro.postwalk(body[:do], fn node -> force_suspensions(node, args) end)

    quote do
      def unquote(head) do
        %Suspension{fun: fn -> unquote(ast) end}
      end
    end
  end

  def eval(arg), do: Suspension.force(arg)

  defp name_and_args({:when, _, [short_head | _]}) do
    name_and_args(short_head)
  end

  defp name_and_args(short_head) do
    Macro.decompose_call(short_head)
  end

  defp force_suspensions({param, context, nil} = node, args) do
    case param in args do
      true ->
        quote do
          Suspension.force(unquote({param, context, nil}))
        end

      false ->
        node
    end
  end

  defp force_suspensions(node, _), do: node

  defp get_args(args_ast) when is_list(args_ast) do
    Enum.reduce(args_ast, [], &get_arg/2)
  end

  defp get_arg({arg, _context, nil}, arg_list), do: [arg | arg_list]
  defp get_arg(_primitive, arg_list), do: arg_list
end
