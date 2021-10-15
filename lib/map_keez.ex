defmodule MapKeez do
  @moduledoc """
  Convert string map keys to atoms or vice-versa.
  """

  alias MapKeez.Impl

  @type opts :: [recursive: boolean(), convert_map_keys: boolean()]
  @type target_type :: :string | :existing_atom | :atom

  @doc """
  Convert atom keys to string keys.
  """
  @spec to_string_keys(map(), opts) :: %{String.t() => any()}
  def to_string_keys(%{} = map, opts \\ []) do
    map
    |> convert_map_keys(:string, opts)
  end

  @doc """
  Safely convert string keys to atom keys. Raises an `ArgumentError` if a string cannot be successfully converted via `String.to_existing_atom/1`.
  """
  @spec to_atom_keys!(map(), opts) :: %{atom() => any()}
  def to_atom_keys!(%{} = map, opts \\ []) do
    map
    |> convert_map_keys(:existing_atom, opts)
  end

  @doc """
  Unsafely convert string keys to atom keys.
  """
  @spec to_atom_keys_unsafe(map(), opts) :: %{atom() => any()}
  def to_atom_keys_unsafe(%{} = map, opts \\ []) do
    map
    |> convert_map_keys(:atom, opts)
  end

  @spec convert_map_keys(map(), target_type, opts) :: map()
  defp convert_map_keys(map, target_type, opts) do
    map
    |> Impl.convert_map_keys(target_type, opts)
  end
end
