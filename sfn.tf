resource "aws_iam_role" "iam_role_for_map_state_sfn" {
  name = "iam_for_map_state_sfn"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "states.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "map_state_sfn_policy" {
  name        = "map-state-sfn-policy"
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
        "lambda:InvokeFunction"
      ],
      "Resource": "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "dataexchange:ListDataSetRevisions"
      ],
      "Resource": "arn:aws:dataexchange:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "events:PutEvents"
      ],
      "Resource": "arn:aws:events:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem"
      ],
      "Resource": "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "simple_sfn_policy_attachment" {
  role       = aws_iam_role.iam_role_for_map_state_sfn.name
  policy_arn = aws_iam_policy.map_state_sfn_policy.arn
}

#resource "aws_sfn_state_machine" "simple_sfn_state_machine" {
#  name       = "simple-sfn-state-machine"
#  role_arn   = aws_iam_role.iam_role_for_simple_sfn.arn
#  definition = data.template_file.sfn_definition.rendered
#}
#}
