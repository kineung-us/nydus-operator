defmodule NydusOperator.MixProject do
  use Mix.Project

  def project do
    [
      app: :nydus_operator,
      version: System.fetch_env!("APP_VERSION"),
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:bonny, github: "coryodaniel/bonny", ref: "56da8e0aba248782ecbf5bc3e0a724be2ad1925e"},
      {:nested_filter, "~> 1.2.2"},
      {:dialyxir, "~> 1.0.0-rc.4", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:mix_test_watch, "~> 0.8", only: :dev, runtime: false}
    ]
  end
end
