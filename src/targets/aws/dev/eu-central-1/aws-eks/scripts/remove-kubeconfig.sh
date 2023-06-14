#!/bin/bash

remove_users() {
  cluster_name=$1
  region=$2

  user_names=$( kubectl config view -o=json | jq -r -c '
    .users[]? | select(.name | 
      startswith("arn:aws:eks:'$region'") and endswith("/'$cluster_name'")
    ) | .name
  ')
  for user_name in $user_names;
  do
    echo "Deleting user: $user_name"
    kubectl config delete-user $user_name
    sleep 3;
  done
  echo
}

remove_clusters() {
  cluster_name=$1
  region=$2

  cluster_names=$( kubectl config view -o=json | jq -r -c '
    .clusters[]? | select(.name | 
      startswith("arn:aws:eks:'$region'") and endswith("/'$cluster_name'")
    ) | .name
  ')
  for cluster_name in $cluster_names;
  do
    echo "Deleting cluster: $cluster_name"
    kubectl config delete-cluster $cluster_name
    sleep 3;
  done
  echo 
}

remove_contexts() {
  cluster_name=$1
  region=$2

  echo "Attempting to remove contexts with '$region' and '$cluster_name'…"

  first_context=$(kubectl config view -o=json | jq -r -c '
    [
      .contexts[]? | select(.name | (
        (
          startswith("arn:aws:eks:'$region'") and endswith("/'$cluster_name'")
        ) | not)
      ) | .name
    ][0]
  ')
  echo "Switching to context: '$first_context'"
  kubectl config use-context "$first_context"
  sleep 3;

  context_names=$( kubectl config view -o=json | jq -r -c '
    .contexts[]? | select(.name | 
      startswith("arn:aws:eks:'$region'") and endswith("/'$cluster_name'")
    ) | .name
  ')
  echo context_names: $context_names
  for context_name in $context_names;
  do
    echo "Deleting context: $context_name"
    kubectl config delete-context "$context_name"
    sleep 3;
  done
}

cluster_name=$1
region=$2

if [ -z "$cluster_name" ]; then
  echo "Error: This script requires 1st param to be the cluster name"
fi

if [ -z "$region" ]; then
  echo "Error: This script requires 2nd param to be the region"
fi

echo "Starting removal of '$cluster_name' resources from kubeconfig…"
remove_users "$cluster_name" "$region"
remove_clusters "$cluster_name" "$region"
sleep 3
remove_contexts "$cluster_name" "$region"
kubectl config view
echo "Done"
