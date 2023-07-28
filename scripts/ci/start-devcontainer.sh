#!/bin/bash

WORKSPACE_PATH=$1

if [ -z "$WORKSPACE_PATH" ]; then 
  echo "Error: Workspace path needs to be set"
  exit 1
fi

WORKSPACE_PATH=$WORKSPACE_PATH docker compose \
  -f .docker/docker-compose.common.yml \
  -f .docker/docker-compose.e2e.ci.yml \
  up \
  -d
