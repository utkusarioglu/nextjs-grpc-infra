#!/bin/bash

HOSTS_GATEWAY_PHRASE=$1

if [ -z "$HOSTS_GATEWAY_PHRASE" ]; then
  echo "Error: HOSTS_GATEWAY_PHRASE is required to define hosts entries"
  exit 1
fi

source ${0%/*}/common.sh

host_ip=$(get_host_ip)

echo "Config:"
echo "Host ip: $host_ip"
echo "Start phrase: $HOSTS_ENTRIES_START_PHRASE"
echo "End phrase: $HOSTS_ENTRIES_END_PHRASE"
echo "Host gateway phrase: $HOSTS_GATEWAY_PHRASE"

remove_hosts_entries

write_hosts_entries "$host_ip"
exit_code=$?
if [ "$exit_code" != "0" ]; then
  echo "Error: failed to write hosts entries"
  exit $exit_code
fi

echo
display_hosts_file
