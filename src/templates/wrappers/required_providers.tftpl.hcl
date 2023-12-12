// required providers start
terraform {
  required_version = "~> 1.5.3"

  required_providers{
    ${contents}  
  }
}
// required providers end
