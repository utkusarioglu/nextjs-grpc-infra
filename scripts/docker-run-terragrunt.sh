#!/bin/bash

workspace=$(pwd)/..

docker run \
  --user=0:0 \
  -w $PROJECT_ROOT_ABSPATH/infra \
  --env-file .env \
  --add-host=host-gateway:host-gateway \
  --add-host=local.dev.k3d.nextjs-grpc.projects.utkusarioglu.com:host-gateway \
  --add-host=nextjs-grpc.utkusarioglu.com:host-gateway \
  --add-host=grafana.nextjs-grpc.utkusarioglu.com:host-gateway \
  --add-host=jaeger.nextjs-grpc.utkusarioglu.com:host-gateway \
  --add-host=prometheus.nextjs-grpc.utkusarioglu.com:host-gateway \
  --add-host=vault.nextjs-grpc.utkusarioglu.com:host-gateway \
  --add-host=kubernetes-dashboard.nextjs-grpc.utkusarioglu.com:host-gateway \
  --add-host=registry.nextjs-grpc.utkusarioglu.com:host-gateway \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $workspace/infra/.certs/root/root.crt:/usr/local/share/ca-certificates/infra.crt \
  -v $workspace:$PROJECT_ROOT_ABSPATH \
  --entrypoint scripts/terragrunt-apply.sh \
  utkusarioglu/tf-k8s-devcontainer:1.4.experiment-feat-devcontainer-features-15
