defmodule MapKeez do
  @moduledoc """

  """

  alias MapKeez.Impl

  def to_string_keys(map, opts \\ []) do
    map
    |> convert_map_keys(opts, :string)
  end

  # def to_atom_keys!(map, opts \\ []) do
  #   map
  #   |> convert_map_keys(opts, :existing_atom)
  # end

  # def to_atom_keys_unsafe(map, opts \\ []) do
  #   map
  #   |> convert_map_keys(opts, :atom)
  # end

  defp convert_map_keys(map, opts, target_type) do
    map
    |> Impl.convert_map_keys(target_type, opts)
  end
end
