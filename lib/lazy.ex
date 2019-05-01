defmodule Lazy do
  alias LazyAstGenerators, as: Generators

  defmacro deflazy(head, body) do
    {func_name, args_ast} = Generators.name_and_args(head)
    args = Generators.get_args(args_ast)
    impl_body_ast = Generators.impl_body_ast(body, args)
    lazy_impl_ast = Generators.lazy_impl_ast(head, func_name)
    {impl_func_name, _} = Generators.name_and_args(lazy_impl_ast)

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
  def lazy_impl_ast(head, func_name) do
    Macro.postwalk(head, fn
      {func, context, args} when func == func_name ->
        {:"#{func_name}_lazy_implementation", context, args}

      node ->
        node
    end)
  end

  def impl_body_ast(body, args),
    do: Macro.postwalk(body[:do], fn node -> force_suspensions(node, args) end)

  def name_and_args({:when, _, [short_head | _]}) do
    name_and_args(short_head)
  end

  def name_and_args(short_head) do
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

  def get_args(args_ast) when is_list(args_ast) do
    Enum.reduce(args_ast, [], &get_arg/2)
  end

  def get_arg({arg, _context, nil}, arg_list), do: [arg | arg_list]
  def get_arg(_primitive, arg_list), do: arg_list

  defp force_suspensions(node, _), do: node
end
