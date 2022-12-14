locals {
  certs = {
    vault = {
      cert = file(var.intermediate_crt_path)
      ca   = file(var.ca_crt_path)

      bundle = join("", [
        file(var.intermediate_crt_path),
        file(var.ca_crt_path)
      ])
    }
  }
}
