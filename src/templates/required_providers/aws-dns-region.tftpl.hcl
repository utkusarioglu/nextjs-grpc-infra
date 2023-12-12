aws = {
  source                = "hashicorp/aws"
  version               = ">= 4.11.0"
  configuration_aliases = [aws.dns_region]
}
