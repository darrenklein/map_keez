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

      assert %{"foo" => map[:foo], "baz" => map[:baz], "moo" => map["moo"]} == to_string_keys(map)
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
        "existing_key_b" => %{
          "non_existing_key" => "I'm not converted anyway, so no problem"
        }
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
        "blah" => "blah",
        "mwah" => %{
          "chicken" => "wizard"
        }
      }

      assert %{blah: map["blah"], mwah: map["mwah"]} == to_atom_keys_unsafe(map)
    end

    test "raises if a string key exceeds the system limit size for an atom" do
      map = %{
        "long_key_coming_up" => %{
          "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff" =>
            "moo"
        }
      }

      assert_raise SystemLimitError,
                   "a system limit has been reached",
                   fn ->
                     map
                     |> to_atom_keys_unsafe(recursive: true)
                   end
    end
  end

  describe "options" do
    test "recursive option converts all keys found within a map and its nested structures; structs will not be affected" do
    end

    test "recursive and convert_structs options allow keys of a struct and any nested maps to be converted" do
      struct = %TestStruct{}

      assert %{
               atom_key_attributes: %{eye_color: struct.atom_key_attributes.eye_color},
               name: "Bob",
               string_key_attributes: %{height: struct.string_key_attributes["height"]}
             } == struct |> to_atom_keys!(recursive: true, convert_structs: true)
    end

    # test "recursively converts all atom keys in a map structure to strings; structs and their contents will not be converted" do
    #   map = %{
    #     :foo => "bar",
    #     :baz => %{
    #       bim: "blam"
    #     },
    #     "moo" => [
    #       %{:hello => "hello"},
    #       %{"goodbye" => "goodbye"},
    #       %TestStruct{},
    #       :foo
    #     ]
    #   }

    #   assert %{
    #            "foo" => "bar",
    #            "baz" => %{
    #              "bim" => "blam"
    #            },
    #            "moo" => [
    #              %{"hello" => "hello"},
    #              %{"goodbye" => "goodbye"},
    #              %TestStruct{
    #                atom_key_attributes: %{eye_color: "purple"},
    #                name: "Bob",
    #                string_key_attributes: %{"height" => 10}
    #              },
    #              :foo
    #            ]
    #          } == to_string_keys(map, recursive: true)
    # end
  end

  describe "raises on invalid argument" do
    test "atom" do
      assert_raise FunctionClauseError,
                   "no function clause matching in MapKeez.to_string_keys/2",
                   fn ->
                     to_string_keys(:an_atom)
                   end
    end

    test "string" do
      assert_raise FunctionClauseError,
                   "no function clause matching in MapKeez.to_atom_keys!/2",
                   fn ->
                     to_atom_keys!("a string")
                   end
    end

    test "boolean" do
      assert_raise FunctionClauseError,
                   "no function clause matching in MapKeez.to_atom_keys_unsafe/2",
                   fn ->
                     to_atom_keys_unsafe(true)
                   end
    end

    test "integer" do
      assert_raise FunctionClauseError,
                   "no function clause matching in MapKeez.to_atom_keys_unsafe/2",
                   fn ->
                     to_atom_keys_unsafe(1)
                   end
    end

    test "list" do
      assert_raise FunctionClauseError,
                   "no function clause matching in MapKeez.to_string_keys/2",
                   fn ->
                     to_string_keys([:moo, :cow])
                   end
    end
  end
end
