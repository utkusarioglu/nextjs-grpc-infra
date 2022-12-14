provider "aws" {
  region  = "${cluster_region}"
  profile = "${aws_profile}"

  default_tags {
    tags = {
      Environment     = "dev"
      ProjectName     = "nextjs-grpc"
      MetaRepo        = "nextjs-grpc"
      Repo            = "infra/aws"
      Region          = "Cluster region"
      DefaultProvider = "true"
    }
  }
}
