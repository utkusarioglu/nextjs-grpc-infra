#!/bin/bash

artifacts_folder=$1
artifact_file="$artifacts_folder/init.json"
login_file="$artifacts_folder/login.json"
vault_token_file="$HOME/.vault-token"

function get_vault_seal_status {
  kubectl -n vault exec -it vault-0 -- vault status -format json \
  | jq -r '.sealed'
}

function vault_unseal {
  rm -rf "$artifacts_folder"
  mkdir -p "$artifacts_folder"

  kubectl -n vault exec -it vault-0 -- vault operator init -format json \
  1> $artifact_file
  cat $artifact_file | jq -r .root_token > $vault_token_file
}

function vault_login {
  kubectl -n vault exec -it vault-0 -- \
    vault login -format=json $(cat $vault_token_file) > $login_file
}

is_sealed=$(get_vault_seal_status)
attempt_number=0
max_attempts=5

while [ is_sealed != 'false' ]; do
  attempt_number=$((attempt_number + 1))
  echo "Vault operator init attempt: $attempt_number"
  if [ $attempt_number -gt $max_attempts ]; then
    echo "Error: Vault operator init failed after $max_attempts"
    exit 1
  fi
  is_sealed=$(get_vault_seal_status)
  if [ "$is_sealed" != 'false' ]; then
    echo "Starting…"
    vault_unseal
    echo "Sleeping for 60 seconds after attempt…"
    sleep 60
  else 
    echo "Vault is already unsealed, logging in…"
    vault_login
    exit 0
  fi
done
