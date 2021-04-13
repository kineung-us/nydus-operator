defmodule NydusOperator.Controller.V1.External do
  @moduledoc """
  NydusOperator: External CRD.

  ## Kubernetes CRD Spec

  By default all CRD specs are assumed from the module name, you can override them using attributes.

  ### Examples
  ```
  # Kubernetes API version of this CRD, defaults to value in module name
  @version "v2alpha1"

  # Kubernetes API group of this CRD, defaults to "nydus-operator.example.com"
  @group "kewl.example.io"

  The scope of the CRD. Defaults to `:namespaced`
  @scope :cluster

  CRD names used by kubectl and the kubernetes API
  @names %{
    plural: "foos",
    singular: "foo",
    kind: "Foo",
    shortNames: ["f", "fo"]
  }
  ```

  ## Declare RBAC permissions used by this module

  RBAC rules can be declared using `@rule` attribute and generated using `mix bonny.manifest`

  This `@rule` attribute is cumulative, and can be declared once for each Kubernetes API Group.

  ### Examples

  ```
  @rule {apiGroup, resources_list, verbs_list}

  @rule {"", ["pods", "secrets"], ["*"]}
  @rule {"apiextensions.k8s.io", ["foo"], ["*"]}
  ```

  ## Add additional printer columns

  Kubectl uses server-side printing. Columns can be declared using `@additional_printer_columns` and generated using `mix bonny.manifest`

  [Additional Printer Columns docs](https://kubernetes.io/docs/tasks/access-kubernetes-api/custom-resources/custom-resource-definitions/#additional-printer-columns)

  ### Examples

  ```
  @additional_printer_columns [
    %{
      name: "test",
      type: "string",
      description: "test",
      JSONPath: ".spec.test"
    }
  ]
  ```

  """
  use Bonny.Controller

  @group "nydus-operator.mrchypark.github.io"
  @version "v1"

  @scope :cluster
  @names %{
    plural: "externals",
    singular: "external",
    kind: "External",
    shortNames: ["ext"]
  }

  @rule {"apps", ["deployments", "configmaps"], ["*"]}


  @doc """
  Handles an `ADDED` event
  """
  @spec add(map()) :: :ok | :error
  @impl Bonny.Controller
  def add(%{} = external) do
    IO.inspect(external)
    :ok
  end

  @doc """
  Handles a `MODIFIED` event
  """
  @spec modify(map()) :: :ok | :error
  @impl Bonny.Controller
  def modify(%{} = external) do
    IO.inspect(external)
    :ok
  end

  @doc """
  Handles a `DELETED` event
  """
  @spec delete(map()) :: :ok | :error
  @impl Bonny.Controller
  def delete(%{} = external) do
    IO.inspect(external)
    :ok
  end

  @doc """
  Called periodically for each existing CustomResource to allow for reconciliation.
  """
  @spec reconcile(map()) :: :ok | :error
  @impl Bonny.Controller
  def reconcile(%{} = external) do
    IO.inspect(external)
    :ok
  end

  defp parse(%{"metadata" => %{"name" => name, "namespace" => ns}, "spec" => spec}) do
    deployment = gen_deployment(ns, name)
    configmap = gen_configmap(ns, name)
    %{
      deployment: deployment,
      configmap: configmap
    }
  end

  defp gen_configmap(ns, name) do
    %{
      apiVersion: "v1",
      kind: "Configmap",
      metadata: %{
        name: name,
        namespace: ns
      },
      data: %{
        DEBUG: "false",
        ADDRESS: ":5000",
        SOURCE_PUBSUB_NAME: "pubsub",
        SOURCE_TOPIC_NAME: "httpbin",
        VERSION: "external",
        TARGET_ROOT: "https://httpbin.org",
        PUBSUB_TTL: "60",
        INVOKE_TIMEOUT: "60",
        PUBLISH_TIMEOUT: "5",
        CALLBACK_TIMEOUT: "5"
      }
    }
  end

  defp gen_deployment(ns, name) do
    %{
      apiVersion: "apps/v1",
      kind: "Deployment",
      metadata: %{
        name: name,
        namespace: ns,
        labels: %{app: name}
      },
      spec: %{
        replicas: 2,
        selector: %{
          matchLabels: %{app: name}
        },
        template: %{
          metadata: %{
            labels: %{app: name}
          },
          spec: %{
            containers: [
              %{
                name: name,
                image: "mrchypark/nydus:0.0.5",
                ports: [%{containerPort: 5000}]
              }
            ]
          }
        }
      }
    }
  end
end



# apiVersion: apps/v1
# kind: Deployment
# metadata:
#   name: den-nydus
#   labels:
#     helm.sh/chart: nydus-0.0.5
#     app.kubernetes.io/name: nydus
#     app.kubernetes.io/instance: den
#     app.kubernetes.io/version: "1.16.0"
#     app.kubernetes.io/managed-by: Helm
# spec:
#   replicas: 1
#   selector:
#     matchLabels:
#       app.kubernetes.io/name: nydus
#       app.kubernetes.io/instance: den
#   template:
#     metadata:
#       annotations:
#         dapr.io/log-as-json: "true"
#         dapr.io/enabled: "true"
#         dapr.io/log-level: "info"
#         dapr.io/app-id: "den-nydus"
#         dapr.io/app-port: "5000"
#         dapr.io/config: "tracing"
#         dapr.io/sidecar-cpu-limit: 300m
#         dapr.io/sidecar-memory-limit: 1000Mi
#         dapr.io/sidecar-cpu-request: 100m
#         dapr.io/sidecar-memory-request: 250Mi
#         prometheus.io/scrape: "true"
#         prometheus.io/port: "9090"
#         prometheus.io/path: "/"
#         reloader.stakater.com/auto: "true"
#       labels:
#         app.kubernetes.io/name: nydus
#         app.kubernetes.io/instance: den
#     spec:
#       securityContext:
#         fsGroup: 2000
#       containers:
#         - name: nydus
#           securityContext:
#             capabilities:
#               drop:
#               - ALL
#             readOnlyRootFilesystem: true
#             runAsNonRoot: true
#           image: "mrchypark/nydus:0.0.5"
#           imagePullPolicy: IfNotPresent
#           envFrom:
#           - configMapRef:
#               name: den-nydus-configmap
#           env:
#           - name: MY_POD_IP
#             valueFrom:
#               fieldRef:
#                 fieldPath: status.podIP
#           ports:
#             - name: http
#               containerPort: 5000
#               protocol: TCP
#           livenessProbe:
#             httpGet:
#               path: /
#               port: http
#           readinessProbe:
#             httpGet:
#               path: /
#               port: http
#           resources:
#             limits:
#               cpu: 100m
#               memory: 32Mi
#             requests:
#               cpu: 100m
#               memory: 32Mi
