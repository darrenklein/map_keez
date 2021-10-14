defmodule MapKeez do
  @moduledoc """
  Convert string map keys to atoms or vice-versa.
  """

  alias MapKeez.Impl

  def to_string_keys(map, opts \\ []) do
    map
    |> convert_map_keys(:string, opts)
  end

  def to_atom_keys!(map, opts \\ []) do
    map
    |> convert_map_keys(:existing_atom, opts)
  end

  def to_atom_keys_unsafe(map, opts \\ []) do
    map
    |> convert_map_keys(:atom, opts)
  end

  defp convert_map_keys(map, target_type, opts) do
    map
    |> Impl.convert_map_keys(target_type, opts)
  end
end
