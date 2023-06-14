#!/bin/bash

cluster_name=$1
cluster_config_path=$2

index=0
for param_name in cluster_name cluster_config_path; do
  count=$(( index + 1 ))
  if [ -z "${!param_name}" ]; then
    human_name=$(echo $param_name | tr '_' ' ')
    echo "Error: Param no $count needs to be the $human_name"
    exit $count
  fi
  (( index++ ))
done

clusters=$(k3d cluster list -o json)
matching_clusters=$(echo $clusters | jq -r '
  [
    .[] | select(.name | . == "'$cluster_name'") 
  ]
')
cluster_count=$(echo "$matching_clusters" | jq -r 'length')

if [ $cluster_count -gt 1 ]; then
  echo "Error: Given cluster name matches more than one cluster."
  echo "Halting operation to prevent data loss."
  exit 2
elif [ $cluster_count -lt 1 ]; then
  echo "Creating cluster '$cluster_name'…"
  k3d cluster create -c "$cluster_config_path"
  exit 0 
fi

cluster_servers_running=$(echo $matching_clusters | jq -r '.[0].serversRunning')
cluster_agents_running=$(echo $matching_clusters | jq -r '.[0].agentsRunning')

# @dev 
# code here may need to check whether the cluster has failing nodes, 
# ie: running node count that is more than 0 but less than the values in 
# `serversCount` or `agentsCount` in k3d output.

if [ $cluster_servers_running -eq 0 ] && [ $cluster_agents_running -eq 0 ]; then
  echo "Starting cluster '$cluster_name'…"
  k3d cluster start "$cluster_name"
fi
