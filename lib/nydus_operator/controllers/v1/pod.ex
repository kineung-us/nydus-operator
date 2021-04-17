# defmodule NydusOperator.Controller.V1.Pod do
#   @moduledoc """
#   HelloOperator: Greeting CRD.
#   ## Kubernetes CRD Spec
#   By default all CRD specs are assumed from the module name, you can override them using attributes.
#   ### Examples
#   ```
#   # Kubernetes API version of this CRD, defaults to value in module name
#   @version "v2alpha1"
#   # Kubernetes API group of this CRD, defaults to "hello-operator.example.com"
#   @group "kewl.example.io"
#   The scope of the CRD. Defaults to `:namespaced`
#   @scope :cluster
#   CRD names used by kubectl and the kubernetes API
#   @names %{
#     plural: "foos",
#     singular: "foo",
#     kind: "Foo"
#   }
#   ```
#   ## Declare RBAC permissions used by this module
#   RBAC rules can be declared using `@rule` attribute and generated using `mix bonny.manifest`
#   This `@rule` attribute is cumulative, and can be declared once for each Kubernetes API Group.
#   ### Examples
#   ```
#   @rule {apiGroup, resources_list, verbs_list}
#   @rule {"", ["pods", "secrets"], ["*"]}
#   @rule {"apiextensions.k8s.io", ["foo"], ["*"]}
#   ```
#   """
#   require Logger
#   use Bonny.Controller

#   @group ""
#   @version "v1"

#   @scope :namespaced
#   @names %{
#     plural: "pods",
#     singular: "pod",
#     kind: "Pod",
#     shortNames: ["po"]
#   }

#   @rule {"", ["pods"], ["*"]}

#   @doc """
#   Called periodically for each existing CustomResource to allow for reconciliation.
#   """
#   @spec reconcile(map()) :: :ok | :error
#   @impl Bonny.Controller
#   def reconcile(_) do
#     # track_event(:reconcile, payload)
#     :ok
#   end

#   @doc """
#   Called periodically for each existing CustomResource to allow for reconciliation.
#   """
#   @spec delete(map()) :: :ok | :error
#   @impl Bonny.Controller
#   def delete(_) do
#     # track_event(:delete, payload)
#     :ok
#   end

#   @doc """
#   Creates a kubernetes `deployment` and `service` that runs a "Hello, World" app.
#   """
#   @spec add(map()) :: :ok | :error
#   @impl Bonny.Controller
#   def add(payload) do
#     track_event(:add, payload)
#     pod = parse(payload)
#     track_event(:parsed, pod)

#     if !is_nil(pod) do
#       op = K8s.Client.patch(pod)
#       track_event(:operation, op)

#       case run(op) do
#         {:ok, cre} ->
#           track_event(:build, cre)

#         {:error, error} ->
#           track_event(:create_fail, error)

#         _ ->
#           track_event(:create_else, op)
#       end
#     end
#   end

#   @doc """
#   Creates a kubernetes `deployment` and `service` that runs a "Hello, World" app.
#   """
#   @spec modify(map()) :: :ok | :error
#   @impl Bonny.Controller
#   def modify(payload) do
#     track_event(:add, payload)
#     pod = parse(payload)
#     track_event(:parsed, pod)

#     if !is_nil(pod) do
#       op = K8s.Client.patch(pod)
#       track_event(:operation, op)

#       case run(op) do
#         {:ok, cre} ->
#           track_event(:build, cre)

#         {:error, error} ->
#           track_event(:create_fail, error)

#         _ ->
#           track_event(:create_else, op)
#       end
#     end
#   end

#   defp parse(%{"metadata" => %{"annotations" => annotations}} = resource) do
#     annotations
#     |> get_nydus_values()
#     |> case do
#       %{"enabled" => "true"} = config ->
#         Map.merge(resource, %{"spec" => %{"containers" => [set_container(config)]}})

#       %{"enabled" => "false"} ->
#         nil

#       _ ->
#         nil
#     end
#   end

#   alias NydusOperator.Resource.Default.Pod

#   defp set_container(config) do
#     pod = Pod.new(config)

#     Map.merge(Map.delete(pod, "env"), rm_nil_env(pod["env"]))
#     |> rm_nil()
#   end

#   defp get_nydus_values(annotation) do
#     annotation
#     |> Enum.filter(fn {k, _} -> k =~ "nydus.mrchypark.github.io" end)
#     |> Enum.map(fn {k, v} ->
#       String.replace_prefix(k, "nydus.mrchypark.github.io/", "")
#       |> (&{&1, v}).()
#     end)
#     |> Enum.into(%{})
#   end

#   defp rm_nil(pod) do
#     NestedFilter.drop_by_value(pod, [nil, %{}])
#   end

#   defp rm_nil_env(env) do
#     %{
#       env:
#         for(%{name: k, value: v} <- env, !is_nil(v), do: %{name: k, value: v}) ++
#           for(%{name: k, valueFrom: v} <- env, !is_nil(v), do: %{name: k, valueFrom: v})
#     }
#   end

#   defp run(%K8s.Operation{} = op),
#     do: K8s.Client.run(op, Bonny.Config.cluster_name())

#   defp track_event(type, resource),
#     do: Logger.info("#{type}: #{inspect(resource)}")
# end
