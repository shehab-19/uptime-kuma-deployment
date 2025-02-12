resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support   = true 
  enable_dns_hostnames = true 
  tags = {
    Name = var.vpc-name
  }  
}

resource "aws_default_route_table" "main" {
  
    default_route_table_id = aws_vpc.main.default_route_table_id

  tags = {
    Name = var.private-rtb-name
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.igw-name
  }
  
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    
    Name = var.public-rtb-name
  }

 route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

}

resource "aws_subnet" "public" {
  for_each = var.public-subnet-cidr_block
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value  
  availability_zone = var.az[each.key]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-${each.key}"
  }
}

resource "aws_subnet" "private" {
    for_each = var.private-subnet-cidr_block
    vpc_id = aws_vpc.main.id
    cidr_block = each.value

    tags = {
        Name = "private-${each.key}"
    }  
}

resource "aws_route_table_association" "public" {
    for_each = aws_subnet.public                           # important note here
    subnet_id = each.value.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
    for_each = aws_subnet.private
    subnet_id = each.value.id
    route_table_id = aws_default_route_table.main.id
}

resource "aws_security_group" "allow_ssh_http" {
  description = "Allow SSH and HTTP access"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_public_IP]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    description = "Allow HTTPS access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open to all, or restrict to your IP
  }

   ingress {
    description = "Allow HTTP access to web app"
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open to all, or restrict to your IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.security_group1
  }
}

resource "aws_key_pair" "mykey" {
  key_name   = "mykey"
  public_key = file("~/.ssh/aws-keypair.pub")  
}

resource "aws_instance" "web" {
  ami = "ami-0e1bed4f06a3b463d"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public["subnet1"].id
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
  key_name = aws_key_pair.mykey.key_name

}