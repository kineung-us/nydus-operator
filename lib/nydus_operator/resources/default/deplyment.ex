defmodule NydusOperator.Resource.Default.Deployment do
  def new(name, ns, anno_from_crd, config) do
    %{
      "apiVersion" => "apps/v1",
      "kind" => "Deployment",
      "metadata" => %{
        "name" => name,
        "namespace" => ns,
        "labels" => %{
          "app.kubernetes.io/instance" => "nydus-" <> name,
          "app.kubernetes.io/name" => "nydus-external",
          "app.kubernetes.io/version" => Application.fetch_env!( :nydus_operator,  :nydus_version),
          "app.kubernetes.io/managed-by" => "nydus-operator"
        },
      },
      "spec" => %{
        "replicas" => 1,
        "selector" => %{
          "matchLabels" => %{
            "app.kubernetes.io/instance" => "nydus-" <> name,
            "app.kubernetes.io/name" => "nydus-external",
            "app.kubernetes.io/version" => Application.fetch_env!( :nydus_operator,  :nydus_version),
            "app.kubernetes.io/managed-by" => "nydus-operator"
          }
        },
        "template" => %{
          "metadata" => %{
            "annotations" => annotations(name, config, anno_from_crd),
            "labels" => %{
              "app.kubernetes.io/instance" => "nydus-" <> name,
              "app.kubernetes.io/name" => "nydus-external",
              "app.kubernetes.io/version" => Application.fetch_env!( :nydus_operator,  :nydus_version),
              "app.kubernetes.io/managed-by" => "nydus-operator"
            }
            },
            "spec" => %{
              # "securityContext" => %{
              #   "fsGroup" => 2000
              # },
              "containers" => [
                %{
                  "env" => env(config),
                  "image" => "mrchypark/nydus:" <> Application.fetch_env!( :nydus_operator,  :nydus_version),
                  "livenessProbe" => %{
                    "httpGet" => %{
                      "path" => "/",
                      "port" => "nydus-http",
                      "scheme" => "HTTP"
                    }
                  },
                  "readinessProbe" => %{
                    "httpGet" => %{
                      "path" => "/",
                      "port" => String.to_integer(config["http-port"]),
                      "scheme" => "HTTP"
                    }
                  },
                  "name" => "nydus",
                  "ports" => [
                    %{
                      "name" => "nydus-http",
                      "containerPort" => String.to_integer(config["http-port"])
                    }
                  ],
                  "resources" => %{
                    "limits" => %{
                      "cpu" => "100m",
                      "memory" => "32Mi"
                    },
                    "requests" => %{
                      "cpu" => "100m",
                      "memory" => "32Mi"
                    }
                  },
                  # "securityContext" => %{
                  #   "capabilities" => %{
                  #     "drop" => ["ALL"]
                  #   },
                  #   "readOnlyRootFilesystem" => "true",
                  #   "runAsNonRoot" => "true"
                  # }
                }
              ]
            }
          }
      }
    }
    |> rm_nil
  end

  defp annotations(name, config, from_crd) do
    Map.merge(%{
      "dapr.io/enabled" => "true",
      "dapr.io/app-id" => name,
      "dapr.io/app-port" => config["http-port"],
      "dapr.io/log-as-json" => "true",
      "dapr.io/log-level" => "info",
      "dapr.io/sidecar-cpu-limit" => "300m",
      "dapr.io/sidecar-cpu-request" => "100m",
      "dapr.io/sidecar-memory-limit" => "1000Mi",
      "dapr.io/sidecar-memory-request" => "250Mi",
      "prometheus.io/path" => "/",
      "prometheus.io/port" => "9090",
      "prometheus.io/scrape" => "true"
      }, from_crd)
  end

  defp env(config) do
    [
      %{"name" => "NYDUS_HOST_IP", "valueFrom" => %{"fieldRef" => %{"apiVersion" => "v1", "fieldPath" => "status.podIP"}}},
      %{"name" => "DEBUG", "value" => config["debug"]},
      %{"name" => "NYDUS_HTTP_PORT", "value" => config["http-port"]},
      %{"name" => "SUBSCRIBE_PUBSUB_NAME", "value" => config["subscribe-pubsub-name"]},
      %{"name" => "SUBSCRIBE_TOPIC_NAME", "value" => config["subscribe-topic-name"]},
      %{"name" => "PUBLISH_PUBSUB_NAME", "value" => config["publish-pubsub-name"]},
      %{"name" => "PUBLISH_PUBSUB_TTL", "value" => config["publish-pubsub-ttl-seconds"]},
      %{"name" => "TARGET_ROOT", "value" => config["target-root"]},
      %{"name" => "TARGET_VERSION", "value" => config["target-version"]},
      %{"name" => "INVOKE_TIMEOUT", "value" => config["invoke-timeout-seconds"]},
      %{"name" => "PUBLISH_TIMEOUT", "value" => config["publish-timeout-seconds"]},
      %{"name" => "CALLBACK_TIMEOUT", "value" => config["callback-timeout-seconds"]}
    ]
    |> rm_nil_env
  end

  defp rm_nil_env(env) do
      (for %{"name" => k, "value" => v} <- env, !empty_content(v), do: %{"name" => k, "value" => v}) ++
      (for %{"name" => k, "valueFrom" => v} <- env, !empty_content(v), do: %{"name" => k, "valueFrom" => v})
  end

  defp empty_content(el) do
    cond do
      is_nil(el) -> true
      el == "" -> true
      el == %{} -> true
      true -> false
    end
  end

  defp rm_nil(resource) do
    NestedFilter.drop_by_value(resource, [nil, %{}, ""])
  end
end
