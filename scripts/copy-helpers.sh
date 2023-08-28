#!/bin/bash

region_relpath=$1

HELPERS_BASE_RELPATH='src/helpers'
HELPER_SUFFIX='helper.hcl'
TARGETS_BASE_RELPATH='src/targets'

C_RED='\033[0;31m'
C_GRAY='\033[1;30m'
C_WHITE='\033[1;37m'
C_NONE='\033[0m'

function echo_error {
  echo -e "${C_RED}Error:${C_NONE} $1"
}

function echo_colorized_basedir {
  target_relpath=$1
  region_relpath=$2

  target_basedir=$(echo ${target_relpath/$region_relpath/} | tr -d '/')
  region_short_relpath=${region_relpath/$TARGETS_BASE_RELPATH\//}
  echo -e "  ${C_GRAY}${region_short_relpath}/${C_WHITE}${target_basedir}${C_NONE}"
}

function echo_colorized_helper_name {
  helper_id=$1
  echo -e "  ${C_WHITE}${helper_id}${C_GRAY}.${HELPER_SUFFIX}${C_NONE}"
}

function echo_colorized_region_relpath {
  region_relpath=$1
  unique_path=${region_relpath/$TARGETS_BASE_RELPATH\//}
  echo -e "  ${C_GRAY}${TARGETS_BASE_RELPATH}/${C_WHITE}${unique_path}${C_NONE}"
}

function echo_copy_list {
  declare region_relpath=$1
  local -n target_helper_ids_ref=$2
  local -n region_helper_ids_ref=$3
  local -n target_relpaths_ref=$4

  target_count=${#target_relpaths_ref[@]}
  target_helper_count=${#target_helper_ids_ref[@]}
  region_helper_count=${#region_helper_ids_ref[@]}

  echo "Region path:"
  echo_colorized_region_relpath "$region_relpath"

  if [[ $target_count -gt 0 ]]; then
    echo ""
    echo "Discovered ${target_count} target(s):"
    for target_relpath in ${target_relpaths_ref[*]}; do
      echo_colorized_basedir $target_relpath $region_relpath
    done
  fi
  
  if [[ $target_helper_count -gt 0 ]]; then
    echo ""
    echo "Copied ${target_helper_count} target helper(s):"
    for helper_id in ${target_helper_ids_ref[*]}; do
      echo_colorized_helper_name $helper_id
    done
  fi

  if [[ $region_helper_count -gt 0 ]]; then
    echo ""
    echo "Copied ${region_helper_count} region helper(s):"
    for helper_id in ${region_helper_ids_ref[*]}; do
      echo_colorized_helper_name $helper_id
    done
  fi
}

function copy_helpers {
  declare region_relpath=$1
  local -n target_helper_ids_ref2=$2
  local -n region_helper_ids_ref2=$3
  local -n target_relpaths_ref2=$4

  # target
  for target_relpath in ${target_relpaths_ref2[*]}; do
    for target_helper_id in ${target_helper_ids_ref2[*]}; do
      helper_filename="${target_helper_id}.${HELPER_SUFFIX}"
      helper_relpath="${HELPERS_BASE_RELPATH}/${helper_filename}"
      cp "$helper_filename" "$target_relpath"
    done
  done

  # region
  for region_helper_id in ${region_helper_ids_ref[*]}; do
    helper_filename="${region_helper_id}.${HELPER_SUFFIX}"
    helper_relpath="${HELPERS_BASE_RELPATH}/${helper_filename}"
    cp "$helper_filename" "$region_relpath/"
  done
}

function manage_copy_operation {
  declare region_relpath=$1
  local -n target_helper_ids_ref=$2
  local -n region_helper_ids_ref=$3
  
  if [ ! -d $region_relpath ]; then
    echo_error "Region path '$region_relpath' doesn't exist"
    exit 2
  fi

  declare target_relpaths=($(ls -d $region_relpath/*/))
  
  copy_helpers \
    "$region_relpath" \
    target_helper_ids_ref \
    region_helper_ids_ref \
    target_relpaths

  echo_copy_list \
    "$region_relpath" \
    target_helper_ids \
    region_helper_ids \
    target_relpaths
}

function main {
  declare region_id=$1

  if [ -z "$region_id" ]; then
    echo_error 'Region id is required'
    exit 1
  fi
  
  declare region_relpath
  declare target_helper_ids
  declare region_helper_ids

  case $region_id in
    k3d/dev/local)
      region_relpath="${TARGETS_BASE_RELPATH}/k3d/dev/local"
      target_helper_ids+=(
        lineage 
        logic.target.k3d
      )
      region_helper_ids+=(
        lineage 
      )
    ;;

    *)
      echo_error 'Unregistered region id'
      exit 2
    ;;
  esac

  manage_copy_operation \
    "$region_relpath" \
    target_helper_ids \
    region_helper_ids
}

main $@
