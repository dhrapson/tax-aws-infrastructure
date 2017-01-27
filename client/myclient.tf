provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_iam_user" "clients" {
    count = "${length(var.client_names)}"
    name = "${element(var.client_names, count.index)}"
    path = "/${var.integrator_name}/"
}

resource "aws_iam_access_key" "clients" {
    count = "${length(var.client_names)}"
    user = "${element(var.client_names, count.index)}"
}

resource "aws_iam_group_membership" "myintegrator-client" {
    name = "${var.integrator_name}-${element(var.client_names, count.index)}-group-membership"
    users = [
        "${var.client_names}"
    ]
    group = "${var.integrator_name}-client"
}
