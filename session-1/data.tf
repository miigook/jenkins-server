# data "aws_vpc" "jenkinsVPC" {
#   filter {
#     name   = "tag:Name"
#     values = ["JenkinsVPC"]  # Replace with your VPC Name
#   }
# }

#  data "aws_subnet" "public_subnet" {
#   filter {
#     name   = "tag:Name"
#     values = ["Jenkins-public-subnet0"]  # Replace with your specific subnet name
#   }
# }

# data "aws_vpc" "default_vpc" {
#     default = true
# }