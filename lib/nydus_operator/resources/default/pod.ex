defmodule NydusOperator.Resource.Default.Pod do
  def new(config) do
    %{
      image: "mrchypark/nydus:" + Application.fetch_env!(:nydus_operator, :version),
      imagePullPolicy: "Always",
      name: "nydus",
      env: [
        %{name: "MY_POD_IP", valueFrom: %{fieldRef: %{apiVersion: "v1", fieldPath: "status.podIP"}}},
        %{name: "DEGUB", value: "false"},
        %{name: "APP_PORT", value: "5000"},
        %{name: "SUBSCRIBE_PUBSUB_NAME", value: "false"},
        %{name: "SUBSCRIBE_TOPIC_NAME", value: "false"},
        %{name: "PUBLISH_PUBSUB_NAME", value: "false"},
        %{name: "PUBLISH_PUBSUB_TTL", value: nil},
        %{name: "TARGET_ROOT", value: nil},
        %{name: "TARGET_VERSION", value: nil},
        %{name: "INVOKE_TIMEOUT", value: nil},
        %{name: "PUBLISH_TIMEOUT", value: nil},
        %{name: "CALLBACK_TIMEOUT", value: nil}
      ],
      resources: %{
        limits: %{
          cpu: "100m",
          memory: "32Mi"
        },
        requests: %{
          cpu: "100m",
          memory: "32Mi"
        }
      },
      livenessProbe: %{
        failureThreshold: 3,
        httpGet: %{
          path: "/",
          port: "nydus-http"
        },
        periodSeconds: 10,
        successThreshold: 1,
        timeoutSeconds: 1
      },
      readinessProbe: %{
        failureThreshold: 3,
        httpGet: %{
          path: "/",
          port: "nydus-http"
        },
        periodSeconds: 10,
        successThreshold: 1,
        timeoutSeconds: 1
      },
      ports: [
        %{
          containerPort: 5000,
          name: "nydus-http",
          protocol: "TCP"
        }
      ]
    }
  end
end
