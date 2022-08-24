import logging
import json
import boto3

logger = logging.getLogger()
logger.setLevel(logging.INFO)

sfn = boto3.client("stepfunctions")
adx = boto3.client("dataexchange")


# def describe_sfn_execution(execution_arn):
#     response = sfn.describe_execution(
#         executionArn=execution_arn
#     )
#     return response

{
    "datasets": [
      {
        "dataset_name": "fdi",
        "dataset_id": "de14a68266ee980f174cc1a2cc500632"
      }
    ]
}
# "States.Array($.Revisions[0].DataSetId)"
$.output.Item.status.S


def handler(event, context):
    logger.info(f"Received event: {event}")

    # sfn_execution_info = describe_sfn_execution(execution_arn=event['executionArn'])
    # execution_status = sfn_execution_info['status']

    # logger.info(json.dumps(sfn_execution_info))

    # return json.loads(json.dumps(sfn_execution_info, default=str))
