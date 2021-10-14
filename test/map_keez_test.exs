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
             } == to_string_keys(map, recursive: true)
    end
  end

  describe "to_atom_keys!" do
    test "raises when a string cannot be converted to an existing atom" do
      map = %{
        "does_not_exist" => "blah"
      }

      assert_raise ArgumentError,
                   "errors were found at the given arguments:\n\n  * 1st argument: invalid UTF8 encoding\n",
                   fn ->
                     to_atom_keys!(map)
                   end
    end

    test "safely converts top-level map keys from strings to atoms" do
      _existing_atoms = [:existing_key_a, :existing_key_b]

      map = %{
        "existing_key_a" => "I exist",
        "existing_key_b" => "I, too, exist"
      }

      assert %{
               existing_key_a: "I exist",
               existing_key_b: "I, too, exist"
             } == to_atom_keys!(map)
    end
  end

  describe "to_atom_keys_unsafe" do
    test "unsafely converts top-level map keys from strings to atoms" do
      map = %{
        "blah" => "blah"
      }

      assert %{blah: "blah"} == to_atom_keys_unsafe(map)
    end
  end
end
