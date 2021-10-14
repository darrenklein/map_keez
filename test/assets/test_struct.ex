defmodule MapKeezTest.Assets.TestStruct do
  @moduledoc false

  defstruct name: "Bob",
            string_key_attributes: %{
              "height" => 10
            },
            atom_key_attributes: %{
              eye_color: "purple"
            }
end
