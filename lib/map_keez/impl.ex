defmodule MapKeez.Impl do
  @moduledoc false

  alias MapKeez.KeyConverter

  @default_opts [recursive: false, convert_structs: false]

  @spec convert_map_keys(map(), MapKeez.target_type(), MapKeez.opts()) :: map()
  def convert_map_keys(map, target_type, opts) do
    opts = Keyword.merge(@default_opts, opts)

    map
    |> do_convert_map_keys(target_type, opts)
  end

  @spec do_convert_map_keys(any(), MapKeez.target_type(), MapKeez.opts()) :: map()

  defp do_convert_map_keys(%_{} = struct, target_type, opts) do
    if opts[:convert_structs] do
      struct
      |> Map.from_struct()
      |> do_convert_map_keys(target_type, opts)
    else
      struct
    end
  end

  defp do_convert_map_keys(%{} = map, target_type, opts) do
    map
    |> Map.new(fn {key, val} ->
      val =
        if Keyword.get(opts, :recursive),
          do: do_convert_map_keys(val, target_type, opts),
          else: val

      {KeyConverter.maybe_convert_key(key, target_type), val}
    end)
  end

  defp do_convert_map_keys([_ | _] = list, target_type, opts) do
    list
    |> Enum.map(&do_convert_map_keys(&1, target_type, opts))
  end

  defp do_convert_map_keys(val, _, _), do: val
end
