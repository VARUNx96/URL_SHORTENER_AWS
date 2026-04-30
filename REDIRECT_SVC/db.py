import boto3
import os

REGION = os.getenv("AWS_DEFAULT_REGION", "ap-south-1")
TABLE_NAME = "url_shortener"

dynamodb = boto3.resource("dynamodb", region_name=REGION)
table = dynamodb.Table(TABLE_NAME)

def save_url(code: str, long_url: str):
    table.put_item(
        Item={
            "short_code": code,
            "long_url": long_url
        }
    )

def get_url(code: str):
    resp = table.get_item(Key={"short_code": code})
    item = resp.get("Item")
    return item.get("long_url") if item else None