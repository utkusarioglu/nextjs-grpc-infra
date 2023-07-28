#!/bin/bash

WORKSPACE_PATH=$1
CYPRESS_VERSION=$2

for var in WORKSPACE_PATH CYPRESS_VERSION; do
  if [ -z "${!var}" ]; then 
    echo "Error: variable $var needs to be set"
    exit 1
  fi
done



CYPRESS_VERSION=CYPRESS_VERSION WORKSPACE_PATH=$WORKSPACE_PATH docker compose \
  -f .docker/docker-compose.common.yml \
  -f .docker/docker-compose.e2e.ci.yml \
  up \
  -d
