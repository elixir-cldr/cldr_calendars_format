defmodule Cldr.Calendar.Format.MixProject do
  use Mix.Project

  @version "1.0.0"

  def project do
    [
      app: :ex_cldr_calendars_format,
      version: @version,
      elixir: "~> 1.12",
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      name: "Cldr Calendars Format",
      source_url: "https://github.com/elixir-cldr/cldr_calendars_format",
      docs: docs(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      test_coverage: [tool: ExCoveralls],
      aliases: aliases(),
      elixirc_paths: elixirc_paths(Mix.env()),
      dialyzer: [
        ignore_warnings: ".dialyzer_ignore_warnings",
        plt_add_apps: ~w(inets jason mix)a
      ],
      compilers: Mix.compilers()
    ]
  end

  defp description do
    """
    Customizable calendar formatting (HTML, Markdown and custom) for localised and generalised
    calendars based upon ex_cldr_calendars.
    """
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      maintainers: ["Kip Cole"],
      licenses: ["Apache-2.0"],
      logo: "logo.png",
      links: links(),
      files: [
        "lib",
        "config",
        "mix.exs",
        "README*",
        "CHANGELOG*",
        "LICENSE*",
        "priv"
      ]
    ]
  end

  defp deps do
    [

      {:ex_cldr_numbers, "~> 2.34"},
      {:ex_cldr_calendars, "~> 2.1"},
      {:magical, github: "elixir-cldr/magical", branch: "valarm"},

      {:nimble_csv, "~> 0.5", only: [:dev, :test, :release]},
      {:jason, "~> 1.0"},
      {:ex_doc, "~> 0.18", only: [:release, :dev]},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false}
    ]
  end

  def links do
    %{
      "GitHub" => "https://github.com/kipcole9/cldr_calendars_format",
      "Readme" => "https://github.com/kipcole9/cldr_calendars_format/blob/v#{@version}/README.md",
      "Changelog" =>
        "https://github.com/kipcole9/cldr_calendars_format/blob/v#{@version}/CHANGELOG.md"
    }
  end

  def docs do
    [
      source_ref: "v#{@version}",
      main: "readme",
      logo: "logo.png",
      extras: [
        "README.md",
        "LICENSE.md",
        "CHANGELOG.md"
      ],
      skip_undefined_reference_warnings_on: ["CHANGELOG.md", "README.md"]
    ]
  end

  def aliases do
    []
  end

  defp elixirc_paths(:test), do: ["lib", "mix", "test"]
  defp elixirc_paths(:dev), do: ["lib", "mix", "bench"]
  defp elixirc_paths(_), do: ["lib"]
end
