variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "eu-west-1"
}
variable integrator_name {}

output "region" {
  value = "${var.region}"
}
