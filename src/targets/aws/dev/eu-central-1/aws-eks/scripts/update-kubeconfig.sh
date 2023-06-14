#!/bin/bash

cluster_name=$1
region=$2
profile=$3

if [ -z "$cluster_name" ]; then
  echo "Error: This script requires 1st param to be the cluster name"
fi

if [ -z "$region" ]; then
  echo "Error: This script requires 2nd param to be the region"
fi

if [ -z "$profile" ]; then
  echo "Error: This script requires 3rd param to be the profile"
fi

aws eks update-kubeconfig \
  --profile "$profile" \
  --name "$cluster_name" \
  --region "$region"
update_exit_code=$?

kubectl config view

if [ $update_exit_code != 0 ]; then
  echo "Error: aws kubeconfig update failed"
  exit $update_exit_code
fi
