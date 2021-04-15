defmodule NydusOperator.Resource.Default do
  def deployment() do
    %{
      "apiVersion" => "apps/v1",
      "kind" => "Deployment",
      "metadata" => %{
        "labels" => %{
          "app.kubernetes.io/instance" => "",
          "app.kubernetes.io/name" => "nydus-external",
          "app.kubernetes.io/version" => "0.0.5",
          "app.kubernetes.io/managed-by" => "nydus-operator"
        },
      },
      "spec" => %{
        "replicas" => 1,
        "selector" => %{
          "matchLabels" => %{
            "app.kubernetes.io/name" => "nydus-external"
          }
        },
        "template" => %{
          "metadata" => %{
            "annotations" => %{
              "dapr.io/enabled" => "true",
              "dapr.io/log-as-json" => "true",
              "dapr.io/log-level" => "info",
              "dapr.io/sidecar-cpu-limit" => "300m",
              "dapr.io/sidecar-cpu-request" => "100m",
              "dapr.io/sidecar-memory-limit" => "1000Mi",
              "dapr.io/sidecar-memory-request" => "250Mi",
              "prometheus.io/path" => "/",
              "prometheus.io/port" => "9090",
              "prometheus.io/scrape" => "true"
            }
          },
          "spec" => %{
            "securityContext" => %{
              "fsGroup" => 2000
            },
            "containers" => [
              %{
                "env" => [
                  %{
                    "name" => "MY_POD_IP",
                    "valueFrom" => %{
                      "fieldRef" => %{
                        "fieldPath" => "status.podIP"
                      }
                    }
                  },
                  %{
                    "name" => "DEBUG",
                    "value" => "false"
                  },
                  %{
                    "name" => "APP_PORT",
                    "value" => 5000
                  },
                  %{
                    "name" => "SOURCE_PUBSUB_NAME",
                    "value" => ""
                  },
                  %{
                    "name" => "SOURCE_TOPIC_NAME",
                    "value" => ""
                  },
                  %{
                    "name" => "SOURCE_VERSION",
                    "value" => "external"
                  },
                  %{
                    "name" => "TARGET_ROOT",
                    "value" => ""
                  },
                  %{
                    "name" => "PUBSUB_TTL",
                    "value" => "60"
                  },
                  %{
                    "name" => "INVOKE_TIMEOUT",
                    "value" => "60"
                  },
                  %{
                    "name" => "PUBLISH_TIMEOUT",
                    "value" => "3",
                  },
                  %{
                    "name" => "CALLBACK_TIMEOUT",
                    "value" => "3"
                  }
                ],
                "image" => "mrchypark/nydus:0.0.6",
                "livenessProbe" => %{
                  "httpGet" => %{
                    "path" => "/",
                    "port" => "http",
                    "scheme" => "HTTP"
                  },
                },
                "readinessProbe" => %{
                  "httpGet" => %{
                    "path" => "/",
                    "port" => "http",
                    "scheme" => "HTTP"
                  },
                },
                "name" => "nydus",
                "ports" => [
                  %{
                    "name" => "http",
                    "protocol" => "TCP"
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
                "securityContext" => %{
                  "capabilities" => %{
                    "drop" => [
                      "ALL"
                    ]
                  },
                  "readOnlyRootFilesystem" => "true",
                  "runAsNonRoot" => "true"
                }
              }
            ]
          }
        }
      }
    }
  end
end
