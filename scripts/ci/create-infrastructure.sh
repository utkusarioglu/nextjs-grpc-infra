#!/bin/bash

cd src/targets/k3d/dev/local
pwd

container_command='
  update-ca-certificates
  terragrunt run-all apply --auto-approve --terragrunt-non-interactive
'

docker exec -t \
  nextjs-grpc-infra \
  bash -c "$container_command"
