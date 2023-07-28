#!/bin/bash

cd src/targets/k3d/dev/local
pwd

terragrunt_command='terragrunt run-all apply --auto-approve --terragrunt-non-interactive'

docker exec -t \
  nextjs-grpc-infra \
  bash -c "$terragrunt_command"
