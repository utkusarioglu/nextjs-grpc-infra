provider "aws" {
  region  = "${cluster_region}"
  profile = "${aws_profile}"

  default_tags {
    tags = {
      Platform        = "aws"
      Environment     = "dev"
      ProjectName     = "nextjs-grpc"
      MetaRepo        = "nextjs-grpc"
      Repo            = "infra"
      Region          = "Cluster region"
      DefaultProvider = "true"
    }
  }
}
