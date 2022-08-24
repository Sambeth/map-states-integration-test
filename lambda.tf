resource "aws_lambda_function" "lambda_invoke_sfn_function" {
  function_name = "lambda_invoke_sfn"
  handler       = "lambda_invoke_sfn.handler"
  role          = aws_iam_role.iam_role_for_lambda_invoke_sfn_lambda.arn
  runtime       = "python3.8"
  timeout       = 900

  filename         = data.archive_file.lambda_script_zip.output_path
  source_code_hash = data.archive_file.lambda_script_zip.output_base64sha256
#  environment {
#    variables = {
#    }
#  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_invoke_sfn_policy_attachment,
  ]
}

resource "aws_iam_role" "iam_role_for_lambda_invoke_sfn_lambda" {
  name = "iam_for_lambda_invoke_sfn_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "iam_role_for_lambda_invoke_sfn_lambda_policy" {
  name        = "lambda-sfn-controller-lambda-policy"
  description = "A test policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "iam:PassRole"
      ],
      "Resource": "${aws_iam_role.iam_role_for_map_state_sfn.arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "states:CreateStateMachine",
        "states:DescribeStateMachine",
        "states:StartExecution",
        "states:DescribeExecution"
      ],
      "Resource": "arn:aws:states:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_invoke_sfn_policy_attachment" {
  role       = aws_iam_role.iam_role_for_lambda_invoke_sfn_lambda.name
  policy_arn = aws_iam_policy.iam_role_for_lambda_invoke_sfn_lambda_policy.arn
}
