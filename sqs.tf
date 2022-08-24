resource "aws_sqs_queue" "simple_queue" {
  name = "simple_queue"
}

resource "aws_sqs_queue_policy" "simple_queue_policy" {
  queue_url = aws_sqs_queue.simple_queue.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "EventasToSQSQueue",
      "Effect": "Allow",
      "Principal": {"Service": "events.amazonaws.com"},
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.simple_queue.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_cloudwatch_event_rule.cloudwatch_event_rule.arn}"
        }
      }
    }
  ]
}
POLICY
}