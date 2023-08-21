// required providers start
terraform {
  required_version = "~> 1.5.4"

  required_providers{
    ${contents}  
  }
}
// required providers end
