#!/bin/bash

cd src/targets/k3d/dev/local
pwd

docker exec -t \
  nextjs-grpc-infra \
  'terragrunt run-all apply --auto-approve --terragrunt-non-interactive'
