defmodule MapKeezTest do
  use ExUnit.Case
  doctest MapKeez
  import MapKeez

  describe "to_string_keys" do
    test "converts top-level map keys from atoms to strings" do
      map = %{
        :foo => "bar",
        :baz => %{
          bim: "blam"
        },
        "moo" => "mar"
      }

      assert %{"foo" => "bar", "baz" => %{bim: "blam"}, "moo" => "mar"} == to_string_keys(map)
    end

    test "recursively converts all atom keys in a map structure to strings" do
      map = %{
        :foo => "bar",
        :baz => %{
          bim: "blam"
        },
        "moo" => [
          %{:hello => "hello"},
          %{"goodbye" => "goodbye"}
        ]
      }

      assert %{
        "foo" => "bar",
        "baz" => %{
          "bim" => "blam"
        },
        "moo" => [
          %{"hello" => "hello"},
          %{"goodbye" => "goodbye"}
        ]
      } == to_string_keys(map, [recursive: true])
    end
  end

  describe "to_atom_keys!" do

  end

  describe "to_atom_keys_unsafe" do

  end
end
