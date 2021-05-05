# Nydus Operator

## Helm

```
helm repo add nydus https://kineung-us.github.io/nydus-operator/
helm repo update
helm upgrade nydus nydus/nydus --namespace nydus-system --create-namespace --install
```

## ref

logger: <https://akoutmos.com/post/elixir-logging-loki/>
