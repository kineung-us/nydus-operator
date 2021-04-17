defmodule NydusOperator do
  @moduledoc """
  Documentation for `NydusOperator`.
  """
end

%K8s.Operation{
  api_version: "apps/v1",
  data: %{
    "apiVersion" => "apps/v1",
    "kind" => "Deployment",
    "metadata" => %{"name" => "httpbin", "namespace" => "default"},
    "spec" => %{
      "replicas" => 1,
      "template" => %{
        "metadata" => %{
          "annotations" => %{
            "dapr.io/app-id" => "httpbin",
            "dapr.io/app-port" => "5000",
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
          "containers" => [
            %{
              "env" => [
                %{"name" => "NYDUS_HTTP_PORT", "value" => "5000"},
                %{"name" => "SUBSCRIBE_PUBSUB_NAME", "value" => "pubsub"},
                %{"name" => "SUBSCRIBE_TOPIC_NAME", "value" => "httpbin"},
                %{"name" => "PUBLISH_PUBSUB_NAME", "value" => "pubsub"},
                %{"name" => "PUBLISH_PUBSUB_TTL", "value" => "60"},
                %{"name" => "TARGET_ROOT", "value" => "https://httpbin.org/"},
                %{"name" => "TARGET_VERSION", "value" => "external"},
                %{
                  "name" => "NYDUS_HOST_IP",
                  "valueFrom" => %{
                    "fieldRef" => %{"apiVersion" => "v1", "fieldPath" => "status.podIP"}
                  }
                }
              ],
              "image" => "mrchypark/nydus:0.0.8",
              "livenessProbe" => %{
                "httpGet" => %{"path" => "/", "port" => "nydus-http", "scheme" => "HTTP"}
              },
              "name" => "nydus",
              "ports" => [%{"containerPort" => 5000, "name" => "nydus-http"}],
              "readinessProbe" => %{
                "httpGet" => %{"path" => "/", "port" => 5000, "scheme" => "HTTP"}
              },
              "resources" => %{
                "limits" => %{"cpu" => "100m", "memory" => "32Mi"},
                "requests" => %{"cpu" => "100m", "memory" => "32Mi"}
              },
              "securityContext" => %{
                "capabilities" => %{"drop" => ["ALL"]},
                "readOnlyRootFilesystem" => true,
                "runAsNonRoot" => true
              }
            }
          ],
          "securityContext" => %{"fsGroup" => 2000}
        }
      }
    }
  },
  label_selector: nil,
  method: :post,
  name: "Deployment",
  path_params: [namespace: "default", name: "httpbin"],
  verb: :create
}
