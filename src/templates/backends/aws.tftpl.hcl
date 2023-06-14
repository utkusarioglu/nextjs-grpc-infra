terraform {
  backend "s3" {
    bucket         = "${bucket}"
    key            = "${key}"
    region         = "${region}"
    encrypt        = "${encrypt}"
    dynamodb_table = "${dynamodb_table}"
    profile        = "${profile}"
  }
}
