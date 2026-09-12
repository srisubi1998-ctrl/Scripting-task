terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "us_west_2"
  region = "us-west-2"
}

resource "aws_default_vpc" "default_east" {
  provider = aws.us_east_1
}

resource "aws_default_vpc" "default_west" {
  provider = aws.us_west_2
}

resource "aws_security_group" "sg_east" {
  provider    = aws.us_east_1
  name        = "nginx-sg-east"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = aws_default_vpc.default_east.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_west" {
  provider    = aws.us_west_2
  name        = "nginx-sg-west"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = aws_default_vpc.default_west.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "ubuntu_east" {
  provider    = aws.us_east_1
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

data "aws_ami" "ubuntu_west" {
  provider    = aws.us_west_2
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

resource "aws_instance" "east_server" {
  provider               = aws.us_east_1
  ami                    = data.aws_ami.ubuntu_east.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg_east.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y nginx
              sudo systemctl enable nginx
              sudo systemctl start nginx
              EOF

  tags = {
    Name = "Nginx-Instance-US-East-1"
  }
}

resource "aws_instance" "west_server" {
  provider               = aws.us_west_2
  ami                    = data.aws_ami.ubuntu_west.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg_west.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y nginx
              sudo systemctl enable nginx
              sudo systemctl start nginx
              EOF

  tags = {
    Name = "Nginx-Instance-US-West-2"
  }
}

output "us_east_1_nginx_public_ip" {
  value       = aws_instance.east_server.public_ip
  description = "Public IP of Nginx server in us-east-1"
}

output "us_west_2_nginx_public_ip" {
  value       = aws_instance.west_server.public_ip
  description = "Public IP of Nginx server in us-west-2"
}
