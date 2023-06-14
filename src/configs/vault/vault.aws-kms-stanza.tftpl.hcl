seal "awskms" {
  region     = "${region}"
  kms_key_id = "${aws_kms_key_id_for_vault}"
}
