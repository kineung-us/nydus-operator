defmodule NydusOperator.Controller.V1.Deployment do
  @moduledoc """
  NydusOperator: Deployment CRD.

  ## Kubernetes CRD Spec

  By default all CRD specs are assumed from the module name, you can override them using attributes.

  ### Examples
  ```
  # Kubernetes API version of this CRD, defaults to value in module name
  @version "v2alpha1"

  # Kubernetes API group of this CRD, defaults to "nydus-operator.mrchypark.github.io"
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
  require Logger
  use Bonny.Controller

  @group "apps"
  @version "v1"

  @scope :namespaced
  @names %{
    plural: "deployments",
    singular: "deployment",
    kind: "Deployment",
    shortNames: ["deploy", "dp"]
  }

  @rule {"apps", ["deployments"], ["*"]}

  @doc """
  Handles an `ADDED` event
  """
  @spec add(map()) :: :ok | :error
  @impl Bonny.Controller
  def add(%{} = deployment) do
    IO.inspect(deployment)
    :ok
  end

  @doc """
  Handles a `MODIFIED` event
  """
  @spec modify(map()) :: :ok | :error
  @impl Bonny.Controller
  def modify(%{} = deployment) do
    IO.inspect(deployment)
    :ok
  end

  @doc """
  Called periodically for each existing CustomResource to allow for reconciliation.
  """
  @spec reconcile(map()) :: :ok | :error
  @impl Bonny.Controller
  def reconcile(%{} = deployment) do
    IO.inspect(deployment)
    :ok
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

  defp gen_deployment(ns, name, _) do
    %{
      "apiVersion" => "v1",
      "kind" => "ConfigMap",
      "metadata" => %{
        "name" => name,
        "namespace" => ns
      },
      "data" => %{
        "DEBUG" => "false",
        "ADDRESS" => ":5000",
        "SOURCE_PUBSUB_NAME" => "pubsub",
        "SOURCE_TOPIC_NAME" => "httpbin",
        "VERSION" => "external",
        "TARGET_ROOT" => "https://httpbin.org",
        "PUBSUB_TTL" => "60",
        "INVOKE_TIMEOUT" => "60",
        "PUBLISH_TIMEOUT" => "5",
        "CALLBACK_TIMEOUT" => "5"
      }
    }
  end

  defp run(%K8s.Operation{} = op),
    do: K8s.Client.run(op, Bonny.Config.cluster_name())

  defp track_event(type, resource),
    do: Logger.info("#{type}: #{inspect(resource)}")
end





# defmodule MyProject.Resource do

#   def add_owner_references(resource, owner) do
#     put_in(resource, ["metadata", "ownerReferences"], [owner_reference(owner)])
#   end

#   def owner_reference(resource) do
#     %{
#       "apiVersion" => get_in(resource, ["apiVersion"]),
#       "kind"       => get_in(resource, ["kind"]),
#       "name"       => get_in(resource, ["metadata", "name"]),
#       "uid"        => get_in(resource, ["metadata", "uid"]),
#       # foreground deletion => true
#       # background deletion => false
#       "blockOwnerDeletion" => false,
#       # seems to work without too, but internet says we should add it ...
#       "controller" => true,
#     }
#   end

# end
