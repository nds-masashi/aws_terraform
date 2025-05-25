variable "resourceName" {}
variable "email" {}
variable "domain" {}
variable "user" {}
variable "pass" {}

module "main" {
  source = "../../modules/app"

  resourceName = var.resourceName
  email = var.email
  domain = var.domain
  user = var.user
  pass = var.user
}
