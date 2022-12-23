# data "aws_iam_policy_document" "assume_role" {
#   statement {
#     effect  = "Allow"
#     actions = ["sts:AssumeRole"]

#     principals {
#       type        = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#     }
#   }
# }

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

# resource "aws_iam_role" "vault_kms_unseal" {
#   name               = "vault-kms-role"
#   assume_role_policy = data.aws_iam_policy_document.assume_role.json
# }

# resource "aws_iam_role_policy" "vault_kms_unseal" {
#   name   = "vault-kms-unseal"
#   role   = aws_iam_role.vault_kms_unseal.id
#   policy = data.aws_iam_policy_document.vault_kms_unseal.json
# }
