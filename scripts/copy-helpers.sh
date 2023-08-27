#!/bin/bash

region_path=$1

HELPERS_BASE_RELPATH=src/helpers
HELPER_SUFFIX='helper.hcl'

# RED='\033[0;31m'
GRAY='\033[1;30m'
WHITE='\033[1;37m'
NC='\033[0m' 

if [ -z "$region_path" ]; then
  echo "Error: First param needs to be the region path"
  exit 1
fi

function print_done {
  echo ""
  echo "done."
}

function print_plan {
  region_path=$1
  helper_file_identifiers=$2
  region_path=$3
  target_directories=$4

  REQUIRED_PARAMS='
    region_path
    helper_file_identifiers
    region_path
    target_directories
  '

  for param in $REQUIRED_PARAMS; do
    if [ -z "${!param}" ]; then
      echo "Error: $param is required"
      exit 5
    fi
  done

  echo "Copying $region_path helpers…"

  echo ""
  echo "Files:"
  for helper_file_identifier in $helper_file_identifiers; do
      helper_filename_color="$WHITE$helper_file_identifier$GRAY.$HELPER_SUFFIX$NC"
      echo -e "  $helper_filename_color"
  done

  echo ""
  echo "Targets: "
  for target_directory in $target_directories; do
      target_relpath=${target_directory/$region_path\/}
      target_relpath=${target_relpath/\/}
      target_path_color="$GRAY$region_path/$WHITE$target_relpath$NC"
      echo -e "  $target_path_color"
  done
}

function copy_helpers {
  region_path=$1
  helper_file_identifiers=$2

  REQUIRED_PARAMS='
    region_path
    helper_file_identifiers
  '

  for param in $REQUIRED_PARAMS; do
    if [ -z "${!param}" ]; then
      echo "Error: $param is required"
      exit 3
    fi
  done

  target_directories=$(ls -d $region_path/*/)

  print_plan \
    "$region_path" \
    "$helper_file_identifiers" \
    "$region_path" \
    "$target_directories"

  for helper_file_identifier in $helper_file_identifiers; do
    for target_directory in $target_directories; do
      helper_filename="$helper_file_identifier.$HELPER_SUFFIX"
      helper_source_relpath="$HELPERS_BASE_RELPATH/$helper_filename"
      helper_target_relpath="$target_directory$helper_filename"
      
      cp $helper_source_relpath $helper_target_relpath
    done
  done

  print_done
}

case $region_path in
  k3d/dev/local)
    REGION_PATH=src/targets/k3d/dev/local
    HELPER_FILE_IDENTIFIERS='lineage logic.target.k3d'
    copy_helpers $REGION_PATH "$HELPER_FILE_IDENTIFIERS"
    ;;

  aws/dev/eu-central-1)
    REGION_PATH=src/targets/aws/dev/eu-central-1
    HELPER_FILE_IDENTIFIERS='lineage logic.target.aws'
    copy_helpers $REGION_PATH "$HELPER_FILE_IDENTIFIERS"
    ;;

  *)
    echo "Error: Unrecognized region path"
    exit 2
    ;;
esac
