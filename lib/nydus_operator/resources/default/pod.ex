defmodule NydusOperator.Resource.Default.Pod do
  def new(config) do
    %{
      image: "mrchypark/nydus:" <> Application.fetch_env!(:nydus_operator, :nydus_version),
      imagePullPolicy: "Always",
      name: "nyduso",
      env: [
        %{name: "NYDUS_HOST_IP", valueFrom: %{fieldRef: %{apiVersion: "v1", fieldPath: "status.podIP"}}},
        %{name: "DEBUG", value: config["debug"]},
        %{name: "NYDUS_HTTP_PORT", value: config["nydus-http-port"]},
        %{name: "SUBSCRIBE_PUBSUB_NAME", value: config["subscribe-pubsub-name"]},
        %{name: "SUBSCRIBE_TOPIC_NAME", value: config["subscribe-topic-name"]},
        %{name: "PUBLISH_PUBSUB_NAME", value: config["publish-pubsub-name"]},
        %{name: "PUBLISH_PUBSUB_TTL", value: config["publish-pubsub-ttl"]},
        %{name: "TARGET_ROOT", value: config["target-root"]},
        %{name: "TARGET_VERSION", value: config["target-version"]},
        %{name: "INVOKE_TIMEOUT", value: config["invoke-timeout-seconds"]},
        %{name: "PUBLISH_TIMEOUT", value: config["publish-timeout-seconds"]},
        %{name: "CALLBACK_TIMEOUT", value: config["callback-timeout-seconds"]}
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
          containerPort: config["nydus-http-port"],
          name: "nydus-http",
          protocol: "TCP"
        }
      ]
    }
  end
end
