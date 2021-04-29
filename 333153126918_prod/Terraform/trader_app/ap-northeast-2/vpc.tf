
provider "aws" {
  profile = "default"
  region  = "ap-northeast-2"
}
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/22"
  enable_dns_support   = true
  enable_dns_hostnames = true
}