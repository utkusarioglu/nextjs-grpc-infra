#!/bin/bash

echo "Altering docker.sock ownership…"
chown 1000:1000 /var/run/docker.sock

echo "Adding hosts entries…"
scripts/hosts-entries/add.sh host-gateway
