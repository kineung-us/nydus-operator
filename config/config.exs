use Mix.Config

config :logger, level: :info

config :bonny,
  # Add each CRD Controller module for this operator to load here
  controllers: [
    NydusOperator.Controller.V1.External
  ],
  group: "nydus.kineung.us",
  operator_name: "nydus-operator"

# api_version: "apiextensions.k8s.io/v1"

import_config "#{Mix.env()}.exs"
