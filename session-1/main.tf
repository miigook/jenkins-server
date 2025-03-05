resource "aws_instance" "jenkins_server" {
  ami                     = "ami-04b4f1a9cf54c11d0"
  instance_type           = "t2.medium"
  # subnet_id = data.aws_subnet.public_subnet.id
  vpc_security_group_ids = [ aws_security_group.jenkinsSG.id ]
  associate_public_ip_address = true
  key_name = "amin@macbook"
  iam_instance_profile = "EC2roleForJenkins"
  user_data = file("${path.module}/user_data.sh")

tags = {
    Name = "Jenkins-server"
  }
}

output "ec2_public_ip" {
    value = aws_instance.jenkins_server.public_ip
    description = "EC2 instance public IP"
  
}