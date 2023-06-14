locals {
  certs = {
    vault = {
      key  = base64decode(var.intermediate_key_b64)
      cert = base64decode(var.intermediate_crt_b64)
      ca   = base64decode(var.ca_crt_b64)

      bundle = join("", [
        base64decode(var.intermediate_crt_b64),
        base64decode(var.ca_crt_b64)
      ])
    }
  }
}
