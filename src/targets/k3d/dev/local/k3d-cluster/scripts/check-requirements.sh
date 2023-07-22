#!/bin/bash

repo_root_abspath=$1

# Retrieves these from this import: 
# `HOSTS_ENTRIES_START_PHRASE`
# `HOSTS_ENTRIES_END_PHRASE`
source $repo_root_abspath/.repo.config

function check_docker_sock_ownership {
  docker_sock_path=/var/run/docker.sock
  if [[ ! -O "$docker_sock_path" ]] && [ "$(id -u)" != "0" ]; then
    echo "Error: Docker permissions have not been adjusted."
    return 1
  fi
}

function check_hosts_entries {
  hosts_file_path=/etc/hosts
  hosts_list_start=$(
    cat "$hosts_file_path" \
    | grep "$HOSTS_ENTRIES_START_PHRASE"
  )
  if [ -z "$hosts_list_start" ]; then
    echo "Error: host entries missing"
    return 2
  fi
  hosts_list_end=$(
    cat "$hosts_file_path" \
    | grep "$HOSTS_ENTRIES_END_PHRASE"
  )
  if [ -z "$hosts_list_end" ]; then
    echo "Error: Missing hosts entries end. May imply bug."
    return 3
  fi
}

function check_all {
  echo "Starting checks…"
  err_state=0
  check_docker_sock_ownership
  err_state=$(( $err_state + $? ))
  check_hosts_entries
  err_state=$((err_state + $?))

  if (( $err_state != 0 )); then
    echo 
    echo 'Some checks resulted in errors'
    echo 'Did you forget to run `<repo path>/scripts/prep-for-local.sh`?'
  fi
  return $err_state
}

check_all
