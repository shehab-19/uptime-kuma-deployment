variable "az" {  
    type = map(string)
    
    default = {
        subnet1 = "us-east-1a"
        subnet2 = "us-east-1b"
    }
  
}

variable "vpc-name" {
    default = "my-vpc-2"
}

variable "public-rtb-name" {
    default = "public-rt"
}

variable "private-rtb-name" {
    default = "private-rt"
}

variable "igw-name" {
    default = "main-igw"
}

variable "public-subnet-cidr_block" {
    type = map(string)
    default = {

        subnet1  = "10.0.0.0/18"
        subnet2  = "10.0.128.0/18"
}    
}

variable "private-subnet-cidr_block" {
    type = map(string)
    default = {

        subnet1 = "10.0.64.0/18"
        subnet2 = "10.0.192.0/18"
}    
}


variable "security_group1" {
  
  default = "public-sg-1"

}

variable "my_public_IP" {
  default = "41.34.168.46/32"
}