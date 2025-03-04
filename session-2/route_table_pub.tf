resource "aws_route_table" "app-rt-priv" {
  vpc_id = aws_vpc.jenkinsVPC.id
  
   route {
    cidr_block = var.all_open
    gateway_id = aws_nat_gateway.NatGateway.id
  }
  tags = {
    Name = "Route Table Private"
  }
}

resource "aws_route_table" "app-rt-pub" {
  vpc_id = aws_vpc.jenkinsVPC.id

  route {
    cidr_block = var.all_open
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Route Table Public"
  }
}
############### Public Route Table Assosiation ##########
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.pub)
  subnet_id      = aws_subnet.pub[count.index].id
  route_table_id = aws_route_table.app-rt-pub.id
}

############### Private Route Table Assosiation ##########
resource "aws_route_table_association" "private" {
  count = length(aws_subnet.priv)
  subnet_id      = aws_subnet.priv[count.index].id
  route_table_id = aws_route_table.app-rt-priv.id
}
