# TODO upgrade
aws = {
  source  = "hashicorp/aws"
  version = ">= 4.11.0"
  // version = "5.30.0"
  configuration_aliases = [aws.dns_region]
}
