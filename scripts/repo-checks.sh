check_repo_config_file_existence() {
  if [ ! -f ".repo.config" ];
  then
    echo "Error \`.repo.config\` file is required for this script to work"
    exit 20
  fi
  source .repo.config
}
