defmodule MapKeez.Impl do
  @moduledoc """

  """

  @default_opts [recursive: false]

  def convert_map_keys(map, target_type, opts) do
    opts = Keyword.merge(@default_opts, opts)

    map
    |> do_convert_map_keys(target_type, opts)
  end

  defp do_convert_map_keys(%{} = map, :string, opts) do
    map
    |> Map.new(fn {key, val} ->
      val = if Keyword.get(opts, :recursive), do: do_convert_map_keys(val, :string, opts), else: val

      {maybe_to_string(key), val}
    end)
  end

  defp do_convert_map_keys([_ | _] = list, target_type, opts) do
    list
    |> Enum.map(&do_convert_map_keys(&1, target_type, opts))
  end


  defp do_convert_map_keys(val, _, _), do: val

  # defp do_convert_map_keys(map, :existing_atom, opts) do

  # end

  # defp do_convert_map_keys(map, :atom, opts) do

  # end

  defp maybe_to_string(key) when is_bitstring(key), do: key

  defp maybe_to_string(key) when is_atom(key), do: Atom.to_string(key)
end
