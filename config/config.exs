use Mix.Config

config :logger, level: :debug

if Mix.env() == :dev do
  config :k8s,
    clusters: %{
      dev: %{
        conn: "~/.kube/config"
      }
    }

  config :bonny,
    cluster_name: :dev
end

if Mix.env() == :prod do
  config :k8s,
    clusters: %{
      # An empty config defaults to using pod.spec.serviceAccountName
      default: %{}
    }

  config :bonny,
    cluster_name: :default
end

config :bonny,
  # Add each CRD Controller module for this operator to load here
  controllers: [
    NydusOperator.Controller.V1.External
  ],
  #   # Set the Kubernetes API group for this operator.
  #   # This can be overwritten using the @group attribute of a controller
  group: "nydus.mrchypark.github.io",

  #   # Name must only consist of only lowercase letters and hyphens.
  #   # Defaults to hyphenated mix app name
  operator_name: "nydus-operator",

  #   # Name must only consist of only lowercase letters and hyphens.
  #   # Defaults to hyphenated mix app name
  service_account_name: "nydus-operator",
  api_version: "apiextensions.k8s.io/v1",

  #   # Labels to apply to the operator's resources.
  #   labels: %{
  #     "kewl": "true"
  #   },

  #   # Operator deployment resources. These are the defaults.
  resources: %{
    limits: %{cpu: "200m", memory: "200Mi"},
    requests: %{cpu: "200m", memory: "200Mi"}
  }

#   # Defaults to "current-context" if a config file is provided, override user, cluster. or context here
#   kubeconf_opts: []

config :nydus_operator,
  nydus_version: "0.0.8"
