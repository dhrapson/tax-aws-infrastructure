resource "aws_iam_user" "myclient" {
    name = "${var.client_name}"
    path = "/${var.integrator_name}/"
}

resource "aws_iam_user" "otherclient" {
    name = "${var.otherclient_name}"
    path = "/${var.integrator_name}/"
}


resource "aws_iam_user" "e2eclient" {
    name = "${var.e2eclient_name}"
    path = "/${var.integrator_name}/"
}

resource "aws_iam_group_membership" "myintegrator-client" {
    name = "${var.integrator_name}-${var.client_name}-group-membership"
    users = [
        "${aws_iam_user.myclient.name}",
        "${aws_iam_user.otherclient.name}",
        "${aws_iam_user.e2eclient.name}"
    ]
    group = "${aws_iam_group.myintegrator-client.name}"
}
