variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "eu-west-1"
}
variable "failed_lambdas_alarm_email_topic_arn" {}
variable "account" {}
variable "deployers" {
  description = "Create the below accounts "
  type = "list"
  default = ["ci"]
}

output "region" {
  value = "${var.region}"
}
