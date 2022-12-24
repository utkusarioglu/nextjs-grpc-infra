#!/bin/bash

artifacts_folder=$1

if [ -z "$artifacts_folder" ]; then
  echo "Error: artifacts folder needs to be the first param"
  exit 1
fi

ca_crt=$(kubectl config view --minify --flatten \
  | yq '.clusters.0.cluster.certificate-authority-data')

echo "Creating '$artifacts_folder/ca-b64.crt' file..."
mkdir -p "$artifacts_folder"
touch "$artifacts_folder/ca.b64.crt"
echo "$ca_crt" > "$artifacts_folder/ca.b64.crt"
