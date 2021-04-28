# NydusOperator

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `nydus_operator` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:nydus_operator, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/nydus_operator](https://hexdocs.pm/nydus_operator).



```
kubectl delete -f ./manifest.yaml
rm manifest.yaml
APP_VERSION=0.0.1 mix compile 
APP_VERSION=0.0.1 mix bonny.gen.manifest
kubectl apply -f ./manifest.yaml
APP_VERSION=0.0.1 iex -S mix
```


### ref

logger: <https://akoutmos.com/post/elixir-logging-loki/>