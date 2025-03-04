resource "aws_instance" "jenkins_server" {
  ami                     = "ami-04b4f1a9cf54c11d0"
  instance_type           = "t2.medium"
  subnet_id = data.aws_subnet.public_subnet.id
  vpc_security_group_ids = [ aws_security_group.jenkinsSG.id ]
  associate_public_ip_address = true
  key_name = "amin@macbook"
  iam_instance_profile = "EC2roleForJenkins"
  user_data = <<-EOF
            #!/bin/bash
            #Update
            sudo apt update

            #Install Java and Compiler
            sudo apt-get install default-jre -y
            sudo apt-get install default-jdk -y 

            #Download Jenkins Key and add repository to install
            sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
            https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
            echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
            https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
            /etc/apt/sources.list.d/jenkins.list > /dev/null
            sudo apt-get update
            sudo apt-get install jenkins -y

            #Start and Enable
            sudo systemctl start jenkins
            sudo systemctl enable jenkins

            #Change hostname to jenkins
            hostnamectl set-hostname jenkins
            sudo su jenkins
            sudo cd 

            EOF
  
tags = {
    Name = "Jenkins-server"
  }
}

output "ec2_public_ip" {
    value = aws_instance.jenkins_server.public_ip
    description = "EC2 instance public IP"
  
}