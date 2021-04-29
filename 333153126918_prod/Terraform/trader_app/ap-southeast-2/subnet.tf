resource "aws_subnet" "pub_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-southeast-2c"
  map_public_ip_on_launch = true
}