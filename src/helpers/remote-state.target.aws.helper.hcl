locals {
  lineage_helper_hcl = read_terragrunt_config("./lineage.helper.hcl")
  template_types     = local.lineage_helper_hcl.locals.template_types
  module_hierarchy   = local.lineage_helper_hcl.locals.module_hierarchy
  parents            = local.lineage_helper_hcl.locals.parents
  region             = local.parents.region.inputs.region
  aws_profile        = local.parents.region.inputs.aws_profile
  region_identifier  = local.parents.region.inputs.region_identifier
  cluster_name       = local.parents.region.inputs.cluster_name

  target_identifier = concat(local.region_identifier, [
    "${basename(get_terragrunt_dir())}"
  ])
  target_name = join("-", local.target_identifier)
  s3_key      = join("/", concat(local.target_identifier, ["terraform.tfstate"]))

  remote_state_config = {
    bucket         = local.target_name
    key            = local.s3_key
    region         = local.region
    encrypt        = true
    dynamodb_table = local.target_name
    profile        = local.aws_profile
  }
}
