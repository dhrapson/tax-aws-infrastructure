resource "aws_cloudtrail" "logs" {
    name = "cloudtrail-logs"
    s3_bucket_name = "${aws_s3_bucket.cloudtrail.id}"
    include_global_service_events = true
}

resource "aws_s3_bucket" "cloudtrail" {
    bucket = "wtr-${var.account}-cloudtrail-logs"
    force_destroy = true
    policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::wtr-${var.account}-cloudtrail-logs"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::wtr-${var.account}-cloudtrail-logs/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}
