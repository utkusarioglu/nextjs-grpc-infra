terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.2.3"
    }
  }
}
