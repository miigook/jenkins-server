resource "aws_security_group" "jenkinsSG" {
  name        = "allow_jenkins_server"
  description = "Allow ssh and jenkinsport inbound traffic and all outbound traffic"
  # vpc_id = data.aws_vpc.jenkinsVPC.id

  tags = {
    Name = "JenkinsSG"
    Env = "Jenkins"
    Hometask = "session1"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_jenkins_port" {
  security_group_id = aws_security_group.jenkinsSG.id
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
  cidr_ipv4         = "0.0.0.0/0"
  tags = {
    Name = "JenkinsPort"
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.jenkinsSG.id
  
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
  tags = {
    Name = "WEB-HTTP"
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.jenkinsSG.id
  
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
  tags = {
    Name = "SSL-HTTPS"
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_ip4_ssh" {
  security_group_id = aws_security_group.jenkinsSG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22

  tags = {
    Name = "ssh allowed"
  }
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.jenkinsSG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports

  tags = {
    Name = "all outbound open"
  }
}