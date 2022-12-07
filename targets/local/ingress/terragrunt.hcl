include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_repo_root()}/modules/ingress"

  before_hook "start_k3d_cluster" {
    commands = [
      "apply"
    ]
    working_dir = "/utkusarioglu-com/projects/nextjs-grpc/infra/assets"
    execute     = ["k3d", "cluster", "start", "nextjs-grpc-infra-target-local"]
  }

  after_hook "stop_k3d_cluster" {
    commands = [
      "destroy"
    ]
    working_dir = "/utkusarioglu-com/projects/nextjs-grpc/infra/assets"
    execute     = ["k3d", "cluster", "stop", "nextjs-grpc-infra-target-local"]
  }
}
