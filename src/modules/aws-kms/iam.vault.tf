data "aws_iam_policy_document" "vault_kms_unseal" {
  statement {
    sid       = "VaultKMSUnseal"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey",
      "ec2:DescribeInstances"
    ]
  }
}

resource "aws_iam_policy" "vault_kms_unseal" {
  name        = "vault-kms-unseal"
  description = "Policy that allows certain nodes to unseal their vault instances"
  policy      = data.aws_iam_policy_document.vault_kms_unseal.json
}
