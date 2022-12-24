#!/bin/bash

artifacts_folder=/tmp/nextjs-grpc
ca_crt=$(kubectl config view --minify --flatten \
  | yq '.clusters.0.cluster.certificate-authority-data')

echo "Creating '$artifacts_folder/ca-b64.crt' file..."
echo "$ca_crt" > "$artifacts_folder/ca.b64.crt"
