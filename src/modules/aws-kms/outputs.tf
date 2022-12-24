output "aws_vault_kms_unseal_policy_arn" {
  value = aws_iam_policy.vault_kms_unseal.arn
}

output "aws_kms_key_id_for_vault" {
  value = aws_kms_key.vault.id
}
