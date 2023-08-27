#!/bin/bash

region_path=$1

if [ -z "$region_path" ]; then
  echo "Error: First param needs to be the region path"
  exit 1
fi

case $region_path in
  k3d/dev/local)
    echo "Copying k3d/dev/local helpers…"
    region_path=src/targets/k3d/dev/local
    target_directories=$(ls -d $region_path/*/)
    helper_file_identifiers='lineage logic.target.k3d'
    helpers_basepath=src/helpers

    for target_directory in $target_directories; do
      echo "$target_directory"
      for helper_file_identifier in $helper_file_identifiers; do
        helper_filename="$helper_file_identifier.helper.hcl"
        helper_relpath="$helpers_basepath/$helper_file_identifier"
        helper_target="$target_directory$helper_filename"
        echo "  -> $helper_target"
      done
      echo ""
    done
    # echo $directories
    ;;

  *)
    echo "Error: Unrecognized region path"
    exit 2
    ;;
esac
