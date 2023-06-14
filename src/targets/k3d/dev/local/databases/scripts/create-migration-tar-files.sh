#!/bin/bash

migration_artifacts_abspath=$1
migrations_sql_tar_path=$2
migrations_sql_source_path=$3
migrations_data_tar_path=$4
migrations_data_source_path=$5

required_vars="
migration_artifacts_abspath
migrations_sql_tar_path
migrations_sql_source_path
migrations_data_tar_path
migrations_data_source_path
"

for arg in $required_vars; do
  if [ -z "${!arg}" ]; then
    echo "Error: $arg is a required variable"
    exit 1
  fi
done

echo "Using arg values:"
for arg in $required_vars; do
  echo "$arg=${!arg}"
done
echo "--"

mkdir -p "$migration_artifacts_abspath"

tar -zcvf \
  "$migrations_sql_tar_path" \
  -C "$migrations_sql_source_path" \
  .

tar -zcvf \
  "$migrations_data_tar_path" \
  -C "$migrations_data_source_path" \
  .
