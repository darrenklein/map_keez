defmodule MapKeezTest do
  use ExUnit.Case
  doctest MapKeez
  import MapKeez
  alias MapKeezTest.Assets.TestStruct

  describe "to_string_keys" do
    test "an empty map is returned when attempting to convert an empty map to string keys" do
      assert %{} == to_string_keys(%{})
    end

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

    test "recursively converts all atom keys in a map structure to strings; structs and their contents will not be converted" do
      map = %{
        :foo => "bar",
        :baz => %{
          bim: "blam"
        },
        "moo" => [
          %{:hello => "hello"},
          %{"goodbye" => "goodbye"},
          %TestStruct{},
          :foo
        ]
      }

      assert %{
               "foo" => "bar",
               "baz" => %{
                 "bim" => "blam"
               },
               "moo" => [
                 %{"hello" => "hello"},
                 %{"goodbye" => "goodbye"},
                 %TestStruct{
                   atom_key_attributes: %{eye_color: "purple"},
                   name: "Bob",
                   string_key_attributes: %{"height" => 10}
                 },
                 :foo
               ]
             } == to_string_keys(map, recursive: true)
    end
  end

  describe "to_atom_keys!" do
    test "an empty map is returned when attempting to convert an empty map to existing atom keys" do
      assert %{} == to_atom_keys!(%{})
    end

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
               existing_key_a: map["existing_key_a"],
               existing_key_b: map["existing_key_b"]
             } == to_atom_keys!(map)
    end
  end

  describe "to_atom_keys_unsafe" do
    test "an empty map is returned when attempting to unsafely convert an empty map to atom keys" do
      assert %{} == to_atom_keys_unsafe(%{})
    end

    test "unsafely converts top-level map keys from strings to atoms" do
      map = %{
        "blah" => "blah"
      }

      assert %{blah: "blah"} == to_atom_keys_unsafe(map)
    end
  end
end
