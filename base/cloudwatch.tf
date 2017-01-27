resource "aws_cloudwatch_metric_alarm" "failed_lambda" {
    alarm_name = "failed_lambdas_alarm_${var.account}"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "1"
    metric_name = "Errors"
    namespace = "AWS/Lambda"
    period = "120"
    statistic = "SampleCount"
    threshold = "1"
    alarm_description = "This metric monitors lambda failure"
    insufficient_data_actions = []
    alarm_actions = [ "${var.failed_lambdas_alarm_email_topic_arn}"]
}
