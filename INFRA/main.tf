provider "aws" {
  region = "us-east-1"
}

resource "aws_dynamodb_table" "url_table" {
    name = "url_shortener"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "short_code"
    attribute {
      name = "short_code"
      type = "S"
    }
    tags = {
        name = "url-shortener-table"
    }
}