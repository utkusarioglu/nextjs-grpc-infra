source .env

MAIN_VAR_FILE="vars/$TF_VARS_MAIN_FILE_NAME.$ENVIRONMENT.tfvars"

check_env_for_terraform_values () {
  if [ -z "$ENVIRONMENT" ];
  then
    echo "Warn: \`.env.ENVIRONMENT\` hasn't been set. Using '$DEFAULT_ENVIRONMENT_NAME' for this script."
    ENVIRONMENT=$DEFAULT_ENVIRONMENT_NAME
  fi
}

check_tfvars_in_repo_config() {
  if [ -z "$TF_VARS_MAIN_FILE_NAME" ];
  then
    echo "Error: \`.repo.config.TF_VARS_MAIN_FILE_NAME\` needs to be set for this script to work"
    exit 21
  fi

  if [ ! -f "vars/$TF_VARS_MAIN_FILE_NAME.$ENVIRONMENT.tfvars" ];
  then
    echo "Error: The main tfvars file 'vars/$TF_VARS_MAIN_FILE_NAME.$ENVIRONMENT.tfvars' has to exist for this script to work"
    exit 22
  fi
}

check_ingress_file_config() {
  if [ -z "$TF_VARS_INGRESS_FILE_NAME" ];
  then
    echo "Error: `.repo.config.TF_VARS_INGRESS_FILE_NAME` needs to be set for this script to work"
    exit 30
  fi
}
