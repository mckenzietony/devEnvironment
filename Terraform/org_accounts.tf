resource "aws_organizations_account" "dev" {
  name  = "trader-bois-dev"
  email = "trader-bois-dev@stonks.com"

  iam_user_access_to_billing = "ALLOW"

  tags = {
    Name  = "trader-bois-dev"
    Owner = "Tony"
    Role  = "development"
  }
}

resource "aws_organizations_account" "stage" {
  name  = "trader-bois-stage"
  email = "trader-bois-stage@stonks.com"

  iam_user_access_to_billing = "ALLOW"

  tags = {
    Name  = "trader-bois-stage"
    Owner = "Tony"
    Role  = "stage"
  }
}

resource "aws_organizations_account" "prod" {
  name  = "trader-bois-prod"
  email = "trader-bois-prod@stonks.com"

  iam_user_access_to_billing = "ALLOW"

  tags = {
    Name  = "trader-bois-prod"
    Owner = "Tony"
    Role  = "production"
  }
}