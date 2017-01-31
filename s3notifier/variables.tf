variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "eu-west-1"
}
variable "smtp_host" {
	default = "email-smtp.eu-west-1.amazonaws.com"
}
variable "smtp_port" {
	default = "25"
}
variable "smtp_username" {}
variable "smtp_password" {}
variable "s3notifier_email_from" {}
variable "s3notifier_email_to" {}
variable "dropbox_access_token" {}
variable "dropbox_parent_folder" {}

output "region" {
  value = "${var.region}"
}
