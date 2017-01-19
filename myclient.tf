resource "aws_iam_user" "myclient" {
    name = "myclient"
    path = "/integrator-client/myintegrator/"
}

resource "aws_iam_group_membership" "myintegrator-client" {
    name = "myintegrator-client-group-membership"
    users = [
        "${aws_iam_user.myclient.name}"
    ]
    group = "${aws_iam_group.myintegrator-client.name}"
}