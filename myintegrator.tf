provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_iam_group" "myintegrator" {
    name = "myintegrator"
    path = "/"
}

resource "aws_iam_policy" "myintegrator" {
    name = "wtr_myintegrator_policy"
    path = "/myintegrator/"
    description = "Test policy for myintegrator group"
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
                "arn:aws:s3:::myintegrator"
            ]
        },
        {
            "Sid": "AllowAnyLevelListingOfTheBucket",
            "Action": [
                "s3:ListBucket"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::myintegrator/*"
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
            "Resource": "arn:aws:s3:::myintegrator/*"
        },
        {
            "Sid": "AllowManagementOfBucketNotifications",
            "Action": [
                "s3:GetBucketNotification",
                "s3:PutBucketNotification"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::myintegrator"
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
                "iam:UpdateUser",
                "iam:DeleteUser",
                "iam:ListGroupsForUser",
                "iam:ListUserPolicies",
                "iam:ListAttachedUserPolicies",
                "iam:DeleteSigningCertificate",
                "iam:DeleteLoginProfile",
                "iam:RemoveUserFromGroup",
                "iam:DetachUserPolicy",
                "iam:DeleteUserPolicy",
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
            "Resource": "arn:aws:iam::*:group/integrator-client/myintegrator-client"
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
    name = "myintegrator"
    path = "/integrator/"
}

resource "aws_iam_group_membership" "myintegrator" {
    name = "myintegrator-group-membership"
    users = [
        "${aws_iam_user.myintegrator.name}"
    ]
    group = "${aws_iam_group.myintegrator.name}"
}

resource "aws_iam_group" "myintegrator-client" {
    name = "myintegrator-client"
    path = "/integrator-client/"
}

resource "aws_iam_policy" "myintegrator-client" {
    name = "wtr_myintegrator_client_policy"
    path = "/integrator-client/"
    description = "Test policy for myintegrator's clients for WTR"
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
                "arn:aws:s3:::myintegrator"
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
                "arn:aws:s3:::myintegrator"
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
                "arn:aws:s3:::myintegrator"
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
                "s3:*"
            ],
            "Resource": "arn:aws:s3:::myintegrator/$${aws:username}/*"
        },
        {
            "Sid": "AllowManagementOfBucketNotifications",
            "Action": [
                "s3:GetBucketNotification",
                "s3:PutBucketNotification"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::myintegrator"
            ]
        },
        {
            "Sid": "AllowGettingOwnUserDetails",
            "Effect": "Allow",
            "Action": [
                "iam:GetUser"
            ],
            "Resource": [
                "arn:aws:iam::*:user/myintegrator/$${aws:username}"
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
    bucket = "myintegrator"
    acl = "private"
}