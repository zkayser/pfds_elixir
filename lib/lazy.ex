defmodule Lazy do
  alias LazyAstGenerators, as: Generators

  defmacro deflazy(head, body) do
    %{
      impl_func_name: impl_func_name,
      original_args_ast: args_ast,
      lazy_impl_ast: lazy_impl_ast,
      impl_body_ast: impl_body_ast
    } = Generators.build_representations(head, body)

    quote do
      def unquote(head) do
        Suspension.create(__MODULE__, unquote(impl_func_name), unquote(args_ast))
      end

      def unquote(lazy_impl_ast) do
        unquote(impl_body_ast)
      end
    end
  end

  def eval(arg), do: Suspension.force(arg)
end

defmodule LazyAstGenerators do
  @moduledoc """
  Exposes utility functions for generating ASTs used
  in the `deflazy` macro
  """

  def build_representations(head, body) do
    {func_name, args_ast} = name_and_args(head)
    args = get_args(args_ast)
    impl_body_ast = impl_body_ast(body, args)
    lazy_impl_ast = lazy_impl_ast(head, func_name)
    {impl_func_name, _} = name_and_args(lazy_impl_ast)

    %{
      original_args_ast: args_ast,
      impl_func_name: impl_func_name,
      lazy_impl_ast: lazy_impl_ast,
      impl_body_ast: impl_body_ast
    }
  end

  defp lazy_impl_ast(head, func_name) do
    Macro.postwalk(head, fn
      {func, context, args} when func == func_name ->
        {:"#{func_name}_lazy_implementation", context, args}

      node ->
        node
    end)
  end

  defp impl_body_ast(body, args),
    do: Macro.postwalk(body[:do], fn node -> force_suspensions(node, args) end)

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

  defp get_args(args_ast) when is_list(args_ast) do
    Enum.reduce(args_ast, [], &get_arg/2)
  end

  defp get_arg({arg, _context, nil}, arg_list), do: [arg | arg_list]
  defp get_arg(_primitive, arg_list), do: arg_list

  defp force_suspensions(node, _), do: node
end
