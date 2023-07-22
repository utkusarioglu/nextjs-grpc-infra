#!/bin/bash

workspace=$(pwd)/..

cat $PROJECT_ROOT_ABSPATH/infra/.env

docker run \
  --user=0:0 \
  --privileged \
  -w $PROJECT_ROOT_ABSPATH/infra \
  --env-file $PROJECT_ROOT_ABSPATH/infra/.env \
  --add-host=host-gateway:host-gateway \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $workspace:$PROJECT_ROOT_ABSPATH \
  --entrypoint scripts/terragrunt-apply.sh \
  utkusarioglu/tf-k8s-devcontainer:1.4.experiment-feat-devcontainer-features-15

  # -v $workspace/infra/.certs/root/root.crt:/usr/local/share/ca-certificates/infra.crt \
