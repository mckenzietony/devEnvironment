resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

resource "aws_route_table_association" "route_table_association_a" {
  subnet_id      = aws_subnet.pub_subnet_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "route_table_association_c" {
  subnet_id      = aws_subnet.pub_subnet_c.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "route_table_association_d" {
  subnet_id      = aws_subnet.pub_subnet_d.id
  route_table_id = aws_route_table.public.id
}
