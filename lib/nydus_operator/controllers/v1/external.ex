defmodule NydusOperator.Controller.V1.External do
  @moduledoc """
  HelloOperator: Greeting CRD.
  ## Kubernetes CRD Spec
  By default all CRD specs are assumed from the module name, you can override them using attributes.
  ### Examples
  ```
  # Kubernetes API version of this CRD, defaults to value in module name
  @version "v2alpha1"
  # Kubernetes API group of this CRD, defaults to "hello-operator.example.com"
  @group "kewl.example.io"
  The scope of the CRD. Defaults to `:namespaced`
  @scope :cluster
  CRD names used by kubectl and the kubernetes API
  @names %{
    plural: "foos",
    singular: "foo",
    kind: "Foo"
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
  """
  require Logger
  use Bonny.Controller

  @group "nydus-operator.mrchypark.github.io"
  @version "v1"

  @scope :namespaced
  @names %{
    plural: "externals",
    singular: "external",
    kind: "External",
    shortNames: ["ext", "extl"]
  }

  @rule {"apps", ["deployments"], ["*"]}

  @doc """
  Called periodically for each existing CustomResource to allow for reconciliation.
  """
  @spec reconcile(map()) :: :ok | :error
  @impl Bonny.Controller
  def reconcile(payload) do
    track_event(:reconcile, payload)
    :ok
  end

  @doc """
  Creates a kubernetes `deployment` and `service` that runs a "Hello, World" app.
  """
  @spec add(map()) :: :ok | :error
  @impl Bonny.Controller
  def add(payload) do
    track_event(:add, payload)
    resources = parse(payload)

    with {:ok, _} <- K8s.Client.create(resources.deployment) |> run do
      :ok
    else
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Updates `deployment` and `configmap` resources.
  """
  @spec modify(map()) :: :ok | :error
  @impl Bonny.Controller
  def modify(payload) do
    resources = parse(payload)

    with {:ok, _} <- K8s.Client.patch(resources.deployment) |> run do
      :ok
    else
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Deletes `deployment` and `service` resources.
  """
  @spec delete(map()) :: :ok | :error
  @impl Bonny.Controller
  def delete(payload) do
    track_event(:delete, payload)
    resources = parse(payload)

    with {:ok, _} <- K8s.Client.delete(resources.deployment) |> run do
      :ok
    else
      {:error, error} -> {:error, error}
    end
  end

  defp parse(%{
         "metadata" => %{"name" => name, "namespace" => ns},
         "spec" => spec
       }) do
    deployment = gen_deployment(ns, name, spec)

    %{
      deployment: deployment
    }
  end

  defp gen_deployment(ns, name, spec) do
    %{
      "apiVersion" => "apps/v1",
      "kind" => "Deployment",
      "metadata" => %{
        "name" => name,
        "namespace" => ns,
        "labels" => %{"app" => name},
        "spec" => spec
      },
      "spec" => %{
        "replicas" => 1,
        "selector" => %{
          "matchLabels" => %{"app" => name}
        },
        "template" => %{
          "metadata" => %{
            "labels" => %{"app" => name}
          },
          "spec" => %{
            "containers" => [
              %{
                "name" => name,
                "image" => "mrchypark/nydus:0.0.5",
                "ports" => [%{"containerPort" => 5000}]
              }
            ]
          }
        }
      }
    }
  end

  defp run(%K8s.Operation{} = op),
    do: K8s.Client.run(op, Bonny.Config.cluster_name())

  defp track_event(type, resource),
    do: Logger.info("#{type}: #{inspect(resource)}")
end



apiVersion: apps/v1
kind: Deployment
metadata:
  name: den-nydus
  labels:
    helm.sh/chart: nydus-0.0.5
    app.kubernetes.io/name: nydus
    app.kubernetes.io/instance: den
    app.kubernetes.io/version: "0.1.1"
    app.kubernetes.io/managed-by: "nydus-operator"
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: nydus
      app.kubernetes.io/instance: den
  template:
    metadata:
      annotations:
        dapr.io/log-as-json: "true"
        dapr.io/enabled: "true"
        dapr.io/log-level: "info"
        dapr.io/app-id: "den-nydus"
        dapr.io/app-port: "5000"
        dapr.io/config: "tracing"
        dapr.io/sidecar-cpu-limit: 300m
        dapr.io/sidecar-memory-limit: 1000Mi
        dapr.io/sidecar-cpu-request: 100m
        dapr.io/sidecar-memory-request: 250Mi
        prometheus.io/scrape: "true"
        prometheus.io/port: "9090"
        prometheus.io/path: "/"
      labels:
        app.kubernetes.io/name: nydus
        app.kubernetes.io/instance: den
    spec:
      securityContext:
        fsGroup: 2000
      containers:
        - name: nydus
          securityContext:
            capabilities:
              drop:
              - ALL
            readOnlyRootFilesystem: true
            runAsNonRoot: true
          image: "mrchypark/nydus:0.0.5"
          imagePullPolicy: IfNotPresent
          env:
          - name: MY_POD_IP
            valueFrom:
              fieldRef:
                fieldPath: status.podIP
          - name:
            value:

          ports:
            - name: http
              containerPort: 5000
              protocol: TCP
          livenessProbe:
            httpGet:
              path: /
              port: http
          readinessProbe:
            httpGet:
              path: /
              port: http
          resources:
            limits:
              cpu: 100m
              memory: 32Mi
            requests:
              cpu: 100m
              memory: 32Mi



              DEBUG: "false"
              ADDRESS: ":5000"
              SOURCE_PUBSUB_NAME: "pubsub"
              SOURCE_TOPIC_NAME: "httpbin"
              VERSION: "external"
              TARGET_ROOT: "https://httpbin.org"
              PUBSUB_TTL: "60"
              INVOKE_TIMEOUT: "60"
              PUBLISH_TIMEOUT: "5"
              CALLBACK_TIMEOUT: "5"
