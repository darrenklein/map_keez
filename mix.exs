defmodule MapKeez.MixProject do
  use Mix.Project

  def project do
    [
      app: :map_keez,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false}
    ]
  end

  defp aliases do
    [
      code_quality: ["dialyzer", "format", "credo -a"]
    ]
  end
end
