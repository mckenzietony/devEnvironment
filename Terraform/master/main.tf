terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  backend "s3" {
    bucket         = "terrabase-s3terraprodconfigbucket-1kxk4dgv2jtah"
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terrabase-DDBTerraProdState-14R1535JG3ONY"
  }
}
