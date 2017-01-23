resource "aws_iam_user" "myclient" {
    name = "${var.client_name}"
    path = "/${var.integrator_name}/"
}

resource "aws_iam_group_membership" "myintegrator-client" {
    name = "${var.integrator_name}-${var.client_name}-group-membership"
    users = [
        "${aws_iam_user.myclient.name}"
    ]
    group = "${aws_iam_group.myintegrator-client.name}"
}