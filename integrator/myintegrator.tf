provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_iam_group" "myintegrator" {
    name = "${var.integrator_name}"
    path = "/"
}

resource "aws_iam_policy" "myintegrator" {
    name = "wtr_${var.integrator_name}_policy"
    path = "/${var.integrator_name}/"
    description = "Test policy for ${var.integrator_name} group"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowGroupToSeeBucketListInTheConsole",
            "Action": [
                "s3:ListAllMyBuckets",
                "s3:GetBucketLocation"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::*"
            ]
        },
        {
            "Sid": "AllowRootLevelListingOfTheBucket",
            "Action": [
                "s3:ListBucket"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${var.integrator_name}"
            ]
        },
        {
            "Sid": "AllowAnyLevelListingOfTheBucket",
            "Action": [
                "s3:ListBucket"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${var.integrator_name}/*"
            ]
        },
        {
            "Sid": "AllowUserSpecificActionsOnlyInTheBucket",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:DeleteObject",
                "s3:DeleteObjectVersion"
            ],
            "Resource": "arn:aws:s3:::${var.integrator_name}/*"
        },
        {
            "Sid": "AllowManagementOfBucketNotifications",
            "Action": [
                "s3:GetBucketNotification",
                "s3:PutBucketNotification"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${var.integrator_name}"
            ]
        },
        {
            "Sid": "AllowGettingOwnUserDetails",
            "Effect": "Allow",
            "Action": [
                "iam:GetUser"
            ],
            "Resource": [
                "arn:aws:iam::*:user/integrator/$${aws:username}"
            ]
        },
        {
            "Sid": "AllowManagingOwnClientUsersDetails",
            "Effect": "Allow",
            "Action": [
                "iam:CreateUser",
                "iam:ListUsers",
                "iam:GetUser",
                "iam:DeleteUser",
                "iam:ListGroupsForUser",
                "iam:RemoveUserFromGroup",
                "iam:CreateAccessKey",
                "iam:DeleteAccessKey",
                "iam:ListAccessKeys"
            ],
            "Resource": [
                "arn:aws:iam::*:user/$${aws:username}/*"
            ]
        },
        {
            "Sid": "AllowManagementOfClientsGroup",
            "Effect": "Allow",
            "Action": [
              "iam:AddUserToGroup",
              "iam:RemoveUserFromGroup",
              "iam:GetGroup"
            ],
            "Resource": "arn:aws:iam::*:group/integrator-client/${var.integrator_name}-client"
        }
    ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "myintegrator" {
    group = "${aws_iam_group.myintegrator.name}"
    policy_arn = "${aws_iam_policy.myintegrator.arn}"
}

resource "aws_iam_user" "myintegrator" {
    name = "${var.integrator_name}"
    path = "/integrator/"
}

resource "aws_iam_group_membership" "myintegrator" {
    name = "${var.integrator_name}-group-membership"
    users = [
        "${aws_iam_user.myintegrator.name}"
    ]
    group = "${aws_iam_group.myintegrator.name}"
}

resource "aws_iam_group" "myintegrator-client" {
    name = "${var.integrator_name}-client"
    path = "/integrator-client/"
}

resource "aws_iam_policy" "myintegrator-client" {
    name = "wtr_${var.integrator_name}_client_policy"
    path = "/integrator-client/"
    description = "Test policy for ${var.integrator_name}'s clients for WTR"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowGroupToSeeBucketListInTheConsole",
            "Action": [
                "s3:ListAllMyBuckets",
                "s3:GetBucketLocation"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::*"
            ]
        },
        {
            "Sid": "AllowRootLevelListingOfTheBucket",
            "Action": [
                "s3:ListBucket"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${var.integrator_name}"
            ],
            "Condition": {
                "StringEquals": {
                    "s3:prefix": [
                        ""
                    ],
                    "s3:delimiter": [
                        "/"
                    ]
                }
            }
        },
        {
            "Sid": "AllowListBucketOfASpecificUserPrefix",
            "Action": [
                "s3:ListBucket"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${var.integrator_name}"
            ],
            "Condition": {
                "StringLike": {
                    "s3:prefix": [
                        "$${aws:username}"
                    ]
                }
            }
        },
        {
            "Sid": "AllowListBucketContentsOfASpecificUserPrefix",
            "Action": [
                "s3:ListBucket"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${var.integrator_name}"
            ],
            "Condition": {
                "StringLike": {
                    "s3:prefix": [
                        "$${aws:username}/*"
                    ]
                }
            }
        },
        {
            "Sid": "AllowUserSpecificActionsOnlyInTheSpecificUserPrefix",
            "Effect": "Allow",
            "Action": [
              "s3:PutObject",
              "s3:GetObject",
              "s3:GetObjectVersion",
              "s3:DeleteObject",
              "s3:DeleteObjectVersion"
            ],
            "Resource": "arn:aws:s3:::${var.integrator_name}/$${aws:username}/*"
        },
        {
            "Sid": "AllowManagementOfBucketNotifications",
            "Action": [
                "s3:GetBucketNotification",
                "s3:PutBucketNotification"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${var.integrator_name}"
            ]
        },
        {
            "Sid": "AllowGettingOwnUserDetails",
            "Effect": "Allow",
            "Action": [
                "iam:GetUser"
            ],
            "Resource": [
                "arn:aws:iam::*:user/${var.integrator_name}/$${aws:username}"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "myintegrator-client" {
    group = "${aws_iam_group.myintegrator-client.name}"
    policy_arn = "${aws_iam_policy.myintegrator-client.arn}"
}

resource "aws_s3_bucket" "myintegrator" {
    bucket = "${var.integrator_name}"
    acl = "private"
}
