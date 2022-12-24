terraform {
  required_version = ">= 1.1.9"

  # backend "s3" {}

  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 4.11.0"
      configuration_aliases = [aws.dns_region]
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.14.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.6.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.7.2"
    }
  }
}
