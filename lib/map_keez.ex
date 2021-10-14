defmodule MapKeez do
  @moduledoc """
  Convert string map keys to atoms or vice-versa.
  """

  alias MapKeez.Impl

  @type opts :: [recursive: boolean()]
  @type target_type :: :string | :existing_atom | :atom

  @spec to_string_keys(map(), opts) :: %{String.t() => any()}
  def to_string_keys(%{} = map, opts \\ []) do
    map
    |> convert_map_keys(:string, opts)
  end

  @spec to_atom_keys!(map(), opts) :: %{atom() => any()}
  def to_atom_keys!(%{} = map, opts \\ []) do
    map
    |> convert_map_keys(:existing_atom, opts)
  end

  @spec to_atom_keys_unsafe(map(), opts) :: %{atom() => any()}
  def to_atom_keys_unsafe(map, opts \\ []) do
    map
    |> convert_map_keys(:atom, opts)
  end

  @spec convert_map_keys(map(), target_type, opts) :: map()
  defp convert_map_keys(map, target_type, opts) do
    map
    |> Impl.convert_map_keys(target_type, opts)
  end
end
