variable "pub_subents"  {
    type = list(string)
    default = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
    description = "Public subnet CIDRs"
}

variable "priv_subents"  {
    type = list(string)
    default = ["10.0.11.0/24","10.0.22.0/24","10.0.33.0/24"]
    description = "Private subnet CIDRs"
}

variable "availability_zones" {
    type = list(string)
    default = ["us-east-1a","us-east-1b","us-east-1c"]
    description = "AZs for subnets"
}

variable "all_open" {
    type = string
    default = "0.0.0.0/0"
    description = "All open for CIDR, Security"
  
}