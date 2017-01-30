provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_iam_group" "myintegrator" {
    count = "${length(var.integrator_names)}"
    name = "${element(var.integrator_names, count.index)}"
    path = "/"
}

resource "aws_iam_policy" "myintegrator" {
    count = "${length(var.integrator_names)}"
    name = "wtr_${element(var.integrator_names, count.index)}_policy"
    path = "/${element(var.integrator_names, count.index)}/"
    description = "Test policy for ${element(var.integrator_names, count.index)} group"
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
                "arn:aws:s3:::${element(var.integrator_names, count.index)}"
            ]
        },
        {
            "Sid": "AllowRootLevelListingOfTheBucket",
            "Action": [
                "s3:ListBucket"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${element(var.integrator_names, count.index)}"
            ]
        },
        {
            "Sid": "AllowAnyLevelListingOfTheBucket",
            "Action": [
                "s3:ListBucket"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${element(var.integrator_names, count.index)}/*"
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
            "Resource": "arn:aws:s3:::${element(var.integrator_names, count.index)}/*"
        },
        {
            "Sid": "AllowManagementOfBucketNotifications",
            "Action": [
                "s3:GetBucketNotification",
                "s3:PutBucketNotification"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${element(var.integrator_names, count.index)}"
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
            "Resource": "arn:aws:iam::*:group/integrator-client/${element(var.integrator_names, count.index)}-client"
        }
    ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "myintegrator" {
    count = "${length(var.integrator_names)}"
    group = "${element(aws_iam_group.myintegrator.*.name, count.index)}"
    policy_arn = "${element(aws_iam_policy.myintegrator.*.arn, count.index)}"
}

resource "aws_iam_user" "myintegrator" {
    count = "${length(var.integrator_names)}"
    name = "${element(var.integrator_names, count.index)}"
    path = "/integrator/"
}

resource "aws_iam_group_membership" "myintegrator" {
    count = "${length(var.integrator_names)}"
    name = "${element(var.integrator_names, count.index)}-group-membership"
    users = [
        "${element(aws_iam_user.myintegrator.*.name, count.index)}"
    ]
    group = "${element(aws_iam_group.myintegrator.*.name, count.index)}"
}

resource "aws_iam_group" "myintegrator-client" {
    count = "${length(var.integrator_names)}"
    name = "${element(var.integrator_names, count.index)}-client"
    path = "/integrator-client/"
}

resource "aws_iam_policy" "myintegrator-client" {
    count = "${length(var.integrator_names)}"
    name = "wtr_${element(var.integrator_names, count.index)}_client_policy"
    path = "/integrator-client/"
    description = "Test policy for ${element(var.integrator_names, count.index)}'s clients for WTR"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowGroupToSeeMyBucket",
            "Action": [
                "s3:ListAllMyBuckets",
                "s3:GetBucketLocation"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${element(var.integrator_names, count.index)}"
            ]
        },
        {
            "Sid": "AllowRootLevelListingOfTheBucket",
            "Action": [
                "s3:ListBucket"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${element(var.integrator_names, count.index)}"
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
                "arn:aws:s3:::${element(var.integrator_names, count.index)}"
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
                "arn:aws:s3:::${element(var.integrator_names, count.index)}"
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
            "Resource": "arn:aws:s3:::${element(var.integrator_names, count.index)}/$${aws:username}/*"
        },
        {
            "Sid": "AllowManagementOfBucketNotifications",
            "Action": [
                "s3:GetBucketNotification",
                "s3:PutBucketNotification"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${element(var.integrator_names, count.index)}"
            ]
        },
        {
            "Sid": "AllowGettingOwnUserDetails",
            "Effect": "Allow",
            "Action": [
                "iam:GetUser"
            ],
            "Resource": [
                "arn:aws:iam::*:user/${element(var.integrator_names, count.index)}/$${aws:username}"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "myintegrator-client" {
    count = "${length(var.integrator_names)}"
    group = "${element(aws_iam_group.myintegrator-client.*.name, count.index)}"
    policy_arn = "${element(aws_iam_policy.myintegrator-client.*.arn, count.index)}"
}

resource "aws_s3_bucket" "myintegrator" {
    count = "${length(var.integrator_names)}"
    bucket = "${element(var.integrator_names, count.index)}"
    acl = "private"
    policy = <<EOF
{
	"Version": "2012-10-17",
	"Id": "PutObjPolicy",
	"Statement": [
		{
			"Sid": "DenyIncorrectEncryptionHeader",
			"Effect": "Deny",
			"Principal": "*",
			"Action": "s3:PutObject",
			"Resource": "arn:aws:s3:::${element(var.integrator_names, count.index)}/*",
			"Condition": {
				"StringNotEquals": {
					"s3:x-amz-server-side-encryption": "AES256"
				}
			}
		},
		{
			"Sid": "DenyUnEncryptedObjectUploads",
			"Effect": "Deny",
			"Principal": "*",
			"Action": "s3:PutObject",
			"Resource": "arn:aws:s3:::${element(var.integrator_names, count.index)}/*",
			"Condition": {
				"Null": {
					"s3:x-amz-server-side-encryption": "true"
				}
			}
		}
	]
}
EOF
}
