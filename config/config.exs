use Mix.Config

config :bonny,
  # Add each CRD Controller module for this operator to load here
  controllers: [
    NydusOperator.Controller.V1.External
  ],

  # Your kube config file here
  kubeconf_file: "~/.kube/config",

  # Bonny will default to using your current-context, optionally set cluster: and user: here.
  # kubeconf_opts: [cluster: "my-cluster", user: "my-user"]
  kubeconf_opts: []
