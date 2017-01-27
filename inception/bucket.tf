provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_s3_bucket" "terraform" {
    bucket = "wtr-terraform"
    acl = "private"
}

variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "eu-west-1"
}
