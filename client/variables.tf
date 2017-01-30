variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "eu-west-1"
}
variable integrator_names_string {}
variable "client_names" {
  description = "Create the below accounts "
  type = "list"
  default = ["myclient", "otherclient", "e2eclient"]
}

output "region" {
  value = "${var.region}"
}
