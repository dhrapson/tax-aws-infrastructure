provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_iam_user" "clients" {
    count = "${length(var.client_names)}"
    name = "${element(var.client_names, count.index)}"
    path = "/${element(split(",", var.integrator_names_string), 0)}/"
}

resource "aws_iam_access_key" "clients" {
    count = "${length(var.client_names)}"
    user = "${element(var.client_names, count.index)}"
}

resource "aws_iam_group_membership" "myintegrator-client" {
    name = "${element(split(",", var.integrator_names_string), 0)}-${element(var.client_names, count.index)}-group-membership"
    users = [
        "${var.client_names}"
    ]
    group = "${element(split(",", var.integrator_names_string), 0)}-client"
}
