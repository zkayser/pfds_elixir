defprotocol PFDS.Ordered do
  @fallback_to_any true
  def eq(val_1, val_2)

  @fallback_to_any true
  def lt(val_1, val_2)

  @fallback_to_any true
  def leq(val_1, val_2)
end

defimpl PFDS.Ordered, for: Any do
  def eq(val_1, val_2), do: val_1 == val_2
  def lt(val_1, val_2), do: val_1 < val_2
  def leq(val_1, val_2), do: val_1 <= val_2
end
