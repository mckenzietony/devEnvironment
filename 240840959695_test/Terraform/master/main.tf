terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  backend "s3" {
    bucket         = "terrabase-s3terraprodconfigbucket-ie003rpyxgzx"
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terrabase-DDBTerraProdState-FAGXHWYKM2AE"
  }
}
