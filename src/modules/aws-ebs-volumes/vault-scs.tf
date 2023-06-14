resource "kubernetes_storage_class" "vault_scs" {
  for_each = local.deployment_configs.vault_sc.for_each

  depends_on = [
    helm_release.aws_ebs_csi_driver[0]
  ]

  metadata {
    name = each.key
  }
  storage_provisioner = "ebs.csi.aws.com"
  reclaim_policy      = "Delete"
  volume_binding_mode = "WaitForFirstConsumer"
  parameters = {
    "csi.storage.k8s.io/fstype" = "ext4"
    type                        = "gp3"
    encrypted                   = "true"
  }
  # mount_options = [
  #   "file_mode=0700",
  #   "dir_mode=0777",
  #   "uid=1000",
  #   "gid=1000",
  #   # "nfsvers=4.1",
  #   "mfsymlinks",
  #   "nobrl",
  #   "cache=none"
  # ]
  # mount_options = [
  #   "file_mode=0700",
  #   "dir_mode=0777",
  #   "mfsymlinks",
  #   "uid=1000",
  #   "gid=1000",
  #   "nobrl",
  #   "cache=none"
  # ]

  # allowed_topologies {
  #   match_label_expressions {
  #     key = "vault_in_k8s"
  #     values = [
  #       "true"
  #     ]
  #   }
  # }
}
