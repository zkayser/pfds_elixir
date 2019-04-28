defmodule Lazy do
  defmacro deflazy(head, body) do
    {func_name, args_ast} = name_and_args(head)
    args = get_args(args_ast)

    ast = Macro.postwalk(body[:do], fn node -> force_suspensions(node, args) end)

    actual_work_ast =
      Macro.postwalk(head, fn
        {func, context, args} when func == func_name ->
          {:"#{func_name}_lazy_implementation", context, args}

        node ->
          node
      end)

    {worker_func, _} = name_and_args(actual_work_ast)

    quote do
      def unquote(head) do
        Suspension.create(__MODULE__, unquote(worker_func), unquote(args_ast))
      end

      def unquote(actual_work_ast) do
        unquote(ast)
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
