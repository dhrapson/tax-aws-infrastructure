variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "eu-west-1"
}
variable integrator_names_string {}

output "region" {
  value = "${var.region}"
}
