defmodule Lazy do
  defmacro deflazy(head, body) do
    {_, args_ast} = name_and_args(head)
    args = get_args(args_ast)

    add_suspension_forcers = fn
      {param, context, nil} = node ->
        if param in args do
          quote do: Suspension.force(unquote({param, context, nil}))
        else
          node
        end

      node ->
        node
    end

    ast = Macro.postwalk(body[:do], add_suspension_forcers)

    quote do
      def unquote(head) do
        unquote(ast)
        |> Suspension.create()
      end
    end
  end

  defp name_and_args({:when, _, [short_head | _]}) do
    name_and_args(short_head)
  end

  defp name_and_args(short_head) do
    Macro.decompose_call(short_head)
  end

  defp get_args(args_ast) when is_list(args_ast) do
    Enum.reduce(args_ast, [], &get_arg/2)
  end

  defp get_arg({arg, _context, nil}, arg_list), do: [arg | arg_list]
  defp get_arg(_primitive, arg_list), do: arg_list
end
