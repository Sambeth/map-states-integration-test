resource "aws_cloudwatch_event_rule" "cloudwatch_event_rule" {
  name     = "dummy-cloudwatch-event"
  role_arn = aws_iam_role.iam_role_for_dummy_cloudwatch_event_rule.arn

  event_pattern = jsonencode({
    source = ["gstest.dataexchange"],
    detail-type = ["Revision Published To Data Set"],
    resources = ["de14a68266ee980f174cc1a2cc500632"]
  })
}

resource "aws_iam_role" "iam_role_for_dummy_cloudwatch_event_rule" {
  name = "iam_for_dummy_cloudwatch_event_rule"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_cloudwatch_event_target" "dummy_cloudwatch_event_rule_target" {
  rule      = aws_cloudwatch_event_rule.cloudwatch_event_rule.name
  target_id = "dummy_event_to_sns"
  arn       = aws_sqs_queue.simple_queue.arn
}