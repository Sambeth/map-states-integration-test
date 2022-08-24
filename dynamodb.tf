resource "aws_dynamodb_table" "simple_dynamodb_table" {
  name = "Telemetry"
  hash_key = "dataset_id"
  range_key = "revision_id"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "dataset_id"
    type = "S"
  }

  attribute {
    name = "revision_id"
    type = "S"
  }

}