provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_iam_group" "integrator" {
    name = "integrator"
    path = "/"
}

resource "aws_iam_policy" "integrator" {
    name = "wtr_integrator_policy"
    path = "/integrator/"
    description = "Test policy for integrator group"
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
                "arn:aws:s3:::$${aws.username}"
            ]
        },
        {
            "Sid": "AllowAnyLevelListingOfTheBucket",
            "Action": [
                "s3:ListBucket"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::$${aws.username}/*"
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
            "Resource": "arn:aws:s3:::$${aws.username}/*"
        },
        {
            "Sid": "AllowManagementOfBucketNotifications",
            "Action": [
                "s3:GetBucketNotification",
                "s3:PutBucketNotification"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::$${aws.username}"
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
            "Sid": "AllowGettingOwnClientUsersDetails",
            "Effect": "Allow",
            "Action": [
                "iam:CreateUser",
                "iam:ListUsers",
                "iam:GetUser"
            ],
            "Resource": [
                "arn:aws:iam::*:user/integrator-client/$${aws:username}/*"
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
            "Resource": "arn:aws:iam::609701658665:group/integrator-client/$${aws.username}"
        }
    ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "integrator" {
    group = "${aws_iam_group.integrator.name}"
    policy_arn = "${aws_iam_policy.integrator.arn}"
}
