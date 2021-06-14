# Nydus Operator

## Helm

```
helm repo add nydus https://kineung-us.github.io/nydus-operator/
helm repo update

kubectl create ns nydus-system
kubectl label ns nydus-system sidecar-injection=disabled

helm upgrade nydus nydus/nydus --namespace nydus-system --create-namespace --install
```

## Pod

```
bin/nydus_operator remote
```

## ref

logger: <https://akoutmos.com/post/elixir-logging-loki/>
