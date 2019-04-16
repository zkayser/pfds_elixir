defmodule Queue do
  @type t(a) :: {list(a), list(a)}

  @callback empty() :: t(any)
  @callback empty?(t(any)) :: boolean()
  @callback snoc(t(any), any) :: t(any)
  @callback head(t(any)) :: {:ok, any} | {:error, :empty_queue}
  @callback tail(t(any)) :: {:ok, t(any)} | {:error, :empty_queue}
end
