#!/bin/bash

artifacts_folder=artifacts
artifact_file="$artifacts_folder/init.json"
root_token_file="$artifacts_folder/root.token.json"
vault_token_file="$HOME/.vault-token"

unseal() {
  sealed_pods=$@

  for pod in ${sealed_pods//\"/}; do
    status=$(kubectl -n vault exec $pod -- vault status -format=json 2> /dev/null) 
    initialized=$(echo $status | jq -r ".initialized")
    sealed=$(echo $status | jq -r ".sealed")

    if [ "$sealed" == "false" ]; then
      continue
    fi

    if [ $pod == "vault-0" ] && [[ "$sealed_pods" == *"vault-0"* ]]; then
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
    kubectl -n vault exec "$pod" -- vault operator raft join \
      https://vault-0.vault-internal:8200 1> \
      /dev/null
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

get_sealed_pods() {
  kubectl -n vault get po -o=json \
    --field-selector status.phase=Running | \
    jq \
    '.items[] | select(.metadata.name|test("^vault-[0-9]")) | .metadata.name' \
    | sort 2> \
    /dev/null
}

track(){
  sleep_period=10
  sleep_timer=0
  sealed_pods=$(get_sealed_pods)
  sealed_pods_array=($sealed_pods)
  while [ ${#sealed_pods_array[@]} -lt 3 ]
  do
    ((sleep_timer+=$sleep_period))
    echo "Pods aren't ready, waiting… (${sleep_timer}s)"
    sleep $sleep_period
    sealed_pods=$(get_sealed_pods)
    sealed_pods_array=($sealed_pods)
  done
  echo
  unseal $sealed_pods
}

print_status() {
  sealed_counter=0
  for i in {0..2}; do
    sealed=$(kubectl -n vault exec "vault-$i" -- vault status -format=json | jq '.sealed' 2> /dev/null)
    if [ "$sealed" == true ]; then
      ((sealed_counter+=1))
      echo "vault-$i is still sealed"
    fi
  done
  if [ $sealed_counter == 0 ]; then
    echo "Vault cluster is ready"
  fi
}

track
sleep 5
print_status

echo $(cat artifacts/root.token.json | jq -r .auth.client_token) > ~/.vault-token
