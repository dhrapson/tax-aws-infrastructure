
resource "aws_s3_bucket" "lambda_code {
    bucket = "wtr-lambda-pipeline"
    acl = "private"
}
