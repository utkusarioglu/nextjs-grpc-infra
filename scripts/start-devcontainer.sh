#!/bin/bash

workspace_path=$1

if [ -z "$workspace_path" ]; then 
  echo "Error: Workspace path needs to be set"
  exit 1
fi

docker run -t \
  -v $workspace_path:/utkusarioglu-com/projects/nextjs-grpc
    #   image: utkusarioglu/tf-k8s-devcontainer:1.4.experiment-feat-devcontainer-features-15
