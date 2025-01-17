defmodule PersonalWebsite.MixProject do
  use Mix.Project

  def project do
    [
      app: :personal_website,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp aliases() do
    [
      "site.build": ["build", "tailwind default --minify", "esbuild default --minify"]
    ]
  end

  defp deps do
    [
      {:phoenix_live_view, "~> 1.0"},
      {:esbuild, "~> 0.8"},
      {:tailwind, "~> 0.2"}
    ]
  end
end
