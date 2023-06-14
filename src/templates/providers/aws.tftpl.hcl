provider "aws" {
  region  = "${cluster_region}"
  profile = "${aws_profile}"

  default_tags {
    tags = {
      Platform         = "${platform}"
      Environment      = "${environment}"
      Region           = "${region}"
      RegionShort      = "${region_short}"
      ProjectName      = "${project_name}"
      ProjectNameShort = "${project_name_short}"
      MetaRepo         = "${metarepo_name}"
      AwsProfile       = "${aws_profile}"
      Repo             = "infra"
      TfProviderAlias  = "none"
    }
  }
}
