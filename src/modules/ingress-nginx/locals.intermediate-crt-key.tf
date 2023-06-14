locals {
  intermediate_key = base64decode(var.intermediate_key_b64)
  intermediate_crt = base64decode(var.intermediate_crt_b64)
}
