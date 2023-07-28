#!/bin/bash

docker exec -t \
  nextjs-grpc-infra \
  'terragrunt run-all apply --auto-approve --terragrunt-non-interactive'
