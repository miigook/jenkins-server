resource "aws_vpc" "jenkinsVPC" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "JenkinsVPC"
  }
}

resource "aws_subnet" "pub" {
  count = length(var.pub_subents)
  vpc_id     = aws_vpc.jenkinsVPC.id
  cidr_block = var.pub_subents[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "Jenkins-public-subnet${count.index}"
  }
}

resource "aws_subnet" "priv" {
  count = length(var.priv_subents)
  vpc_id     = aws_vpc.jenkinsVPC.id
  cidr_block = var.priv_subents[count.index]
  availability_zone = var.availability_zones[count.index]
  
  tags = {
    Name = "Jenkins-private-subnet${count.index}"
  }
}