#!/bin/bash

target_path=$1

echo $AWS_ROLE_ARN

if [ -z "$target_path" ]; then
  echo "Error: Target path needs to be set"
  exit 1
fi

cd "$target_path"
pwd

container_command='
  terragrunt run-all apply --auto-approve --terragrunt-non-interactive
'

docker exec -t nextjs-grpc-infra bash -c "$container_command"
