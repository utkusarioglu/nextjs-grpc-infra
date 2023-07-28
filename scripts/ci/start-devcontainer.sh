#!/bin/bash

workspace_path=$1

if [ -z "$workspace_path" ]; then 
  echo "Error: Workspace path needs to be set"
  exit 1
fi

cd src/targets/k3d/dev/local
pwd

WORKSPACE_PATH=$workspace_path docker compose \
  -f .docker/docker-compose.common.yml \
  -f .docker/docker-compose.e2e.ci.yml \
  up \
  -d
