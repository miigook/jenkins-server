resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.jenkinsVPC.id

  tags = {
    Name = "Jenkins-igw"
  }
}

resource "aws_nat_gateway" "NatGateway" {
  allocation_id = aws_eip.nat-ip.id
  subnet_id     = aws_subnet.pub[0].id

  tags = {
    Name = "Jenkins-NAT-Gateway"
    Env = "development"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "nat-ip" {
  domain       = "vpc"
}