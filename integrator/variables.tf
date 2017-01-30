variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "eu-west-1"
}
variable integrator_names {
  type = "list"
}

output "region" {
  value = "${var.region}"
}
