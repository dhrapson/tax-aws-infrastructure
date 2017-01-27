variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "eu-west-1"
}
variable integrator_name {}
variable "client_names" {
  description = "Create the below accounts "
  type = "list"
  default = ["myclient", "otherclient", "e2eclient"]
}
