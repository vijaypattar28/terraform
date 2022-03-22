/*
Source - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy

resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = aws_iam_role.test_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "test_role" {
  name = "test_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}
-- Chnanges done to the policy document
1. renamed test_policy to tf_lambda_policy
2. create separate json policy document, iam/lambda-iam.tf and copy the policy after genrating it from aws policy generator
3. assign policy file using file fucntion through interpolation
4. change the name of the test_role to lambda_role
5. Create separate json file for the assume_role_policy and copy the json policy 
6. assign assume policy file using file fucntion through interpolation
7. change test_role.id to lambda_role
*/

resource "aws_iam_role_policy" "tf_lambda_policy" {
  name = "tf_lambda_policy"
  role = aws_iam_role.lambda_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = "${file("iam/lambda-policy.json")}"
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = "${file("iam/lambda-assume-policy.json")}"
}
