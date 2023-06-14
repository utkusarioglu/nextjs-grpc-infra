#!/bin/bash

artifacts_folder=$1

if [ -z "$artifacts_folder" ]; then
  echo "Error: This script needs artifacts folder path to be the first param"
  exit 1
fi

artifact_file="$artifacts_folder/init.json"
root_token_file="$artifacts_folder/root.token.json"
vault_token_file="$HOME/.vault-token"

unseal() {
  running_pods=$@

  for pod in ${running_pods//\"/}; do
    status=$(kubectl -n vault exec $pod -- vault status -format=json 2> /dev/null) 
    initialized=$(echo $status | jq -r ".initialized")
    sealed=$(echo $status | jq -r ".sealed")
    
    if [ "$sealed" == "false" ]; then
      continue
    fi

    if [ $pod == "vault-0" ] && [[ "$running_pods" == *"vault-0"* ]]; then
      echo "Cleaning artifacts folder"
      rm -rf "$artifacts_folder"
      mkdir -p "$artifacts_folder"
    fi

    sleep 3;
    echo "Starting unseal for '$pod'…"
    if [ "$pod" == "vault-0" ]; then
      if [ "$initialized" == "false" ]; then
        echo "$pod is not initialized"
        kubectl -n vault exec "$pod" -- vault operator init \
          -key-shares=5 \
          -key-threshold=3 \
          -format=json > \
          $artifact_file 
      fi
    fi

    if [ -z "$(cat $artifact_file)" ]; then
      echo "Error: Artifact file '$artifact_file' is empty"
      exit 11
    fi

    if [ "$pod" != "vault-0" ]; then
      echo "Joining $pod to 'vault-0'…"
      (kubectl -n vault exec "$pod" -- vault operator raft join \
        https://vault-0.vault-internal:8200) >/dev/null 2>&1
    fi

    unseal_keys=$(jq -r '.unseal_keys_b64[0:3][]' $artifact_file)
    unseal_step=0
    for key in $unseal_keys; do
      ((unseal_step+=1))
      echo "$pod unseal step $unseal_step"
      sleep 3;
      kubectl -n vault exec "$pod" -- vault operator unseal "$key" > /dev/null
    done

    if [ "$pod" == "vault-0" ]; then
      echo "Logging in '$pod'…"
      root_token=$(jq -r '.root_token' $artifact_file)
      if [ -z "$root_token" ]; then 
        echo "Error: Root token is missing for $pod"
        continue
      fi
      kubectl -n vault exec "$pod" -- vault login \
        -format=json "$root_token" > \
        $root_token_file
      echo "You can find your root token at '$root_token_file'"
      cat $artifact_file | jq -r .root_token > $vault_token_file
      echo "Use $vault_token_file for other terraform configs that need vault"
    fi

    echo "Finished unseal for '$pod'"
    echo 
  done
}

get_running_pods() {
  kubectl -n vault get po -o=json \
    --field-selector status.phase=Running | \
    jq \
    '.items[] | select(.metadata.name|test("^vault-[0-9]")) | .metadata.name' \
    | sort 2> \
    /dev/null
}

count_sealed_pods() {
  sealed_counter=0
  for i in {0..2}; do
    vault_response=$(kubectl -n vault exec "vault-$i" -- vault status -format=json)
    sealed=$((echo $vault_response | jq '.sealed') 2> /dev/null)
    if [ "$sealed" == true ]; then
      ((sealed_counter+=1))
    fi
  done
  echo $sealed_counter
}

track(){
  sleep_period=5
  sleep_timer=0
  pod_count=$(kubectl -n vault get sts -o yaml | yq '.items.0.spec.replicas')
  running_pods=$(get_running_pods)
  echo "Expecting $pod_count replicas for unseal…"
  running_pods_array=($running_pods)
  while [ ${#running_pods_array[@]} -lt $pod_count ]
  do
    ((sleep_timer+=$sleep_period))
    echo "Only ${#running_pods_array[@]} of $pod_count pods are ready, waiting for the rest… (${sleep_timer}s)"
    sleep $sleep_period
    running_pods=$(get_running_pods)
    running_pods_array=($running_pods)
  done
  echo "$pod_count of $pod_count pods are ready."
  echo "Getting sealed pods list…"
  sealed_pods=$(count_sealed_pods)
  attempt_no=1
  while [ $sealed_pods -gt 0 ]
  do
    if [ $attempt_no -gt 10 ]; then
      echo "Error: Vault unseal failing despite multiple attempts, exiting"
      exit 110
    fi
    echo "Unseal attempt no $attempt_no for $sealed_pods remaning pods"
    unseal $running_pods
    ((attempt_no++))
    sleep 5
    sealed_pods=$(count_sealed_pods)
  done
}

print_status() {
  sealed_counter=$(count_sealed_pods)
  if [ $sealed_counter -eq 0 ]; then
    kubectl -n vault exec "vault-$i" -- vault status -format=json 
    echo "Vault cluster is ready"
  else 
    echo "Error: Vault cluster is still sealed"
    exit 1
  fi
}

track
print_status
