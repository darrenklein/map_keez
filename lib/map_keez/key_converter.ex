defprotocol MapKeez.KeyConverter do
  @doc """
  Converts a map key value to a target type, either a string or an atom.
  """

  @spec maybe_convert_key(String.t() | atom(), MapKeez.target_type()) :: String.t() | atom()
  def maybe_convert_key(key, target_type)
end

defimpl MapKeez.KeyConverter, for: BitString do
  def maybe_convert_key(key, :existing_atom), do: String.to_existing_atom(key)
  def maybe_convert_key(key, :atom), do: String.to_atom(key)
  def maybe_convert_key(key, _), do: key
end

defimpl MapKeez.KeyConverter, for: Atom do
  def maybe_convert_key(key, :string), do: Atom.to_string(key)
  def maybe_convert_key(key, _), do: key
end
