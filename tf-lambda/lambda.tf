/*
source for resource archive_file - https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/archive_file
source for resource aws_lambda_function - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function
*/

locals{
    lambda_zip_location = "outputs/welcome.zip"
}

data "archive_file" "welcome" {
  type        = "zip"
  source_file = "welcome.py"
  output_path = "${local.lambda_zip_location}"
}



resource "aws_lambda_function" "test_lambda" {
  filename      = "${local.lambda_zip_location}"
  function_name = "welcome"
  role          = aws_iam_role.lambda_role.arn
  handler       = "welcome.hello"

source_code_hash = "${filebase64sha256(local.lambda_zip_location)}"

  runtime = "python3.9"

  environment {
    variables = {
      foo = "bar"
    }
  }
}