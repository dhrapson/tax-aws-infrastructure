resource "aws_iam_user" "deployers" {
  count = "${length(var.deployers)}"
  name = "${element(var.deployers, count.index)}"
  path = "/deployer/"
}

resource "aws_iam_access_key" "deployers" {
  count = "${length(var.deployers)}"
  user = "${element(var.deployers, count.index)}"
}

resource "aws_iam_group" "deployers" {
    name = "deployers"
    path = "/deployers/"
}

resource "aws_iam_policy" "deployers" {
  name = "wtr_deployers_client_policy"
  path = "/deployers/"
  description = "Policy for deployer-type accounts"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "deployers" {
    group = "${aws_iam_group.deployers.name}"
    policy_arn = "${aws_iam_policy.deployers.arn}"
}
