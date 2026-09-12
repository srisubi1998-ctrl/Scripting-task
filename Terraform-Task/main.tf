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
  provider      = aws.us_east_1
  ami           = data.aws_ami.ubuntu_east.id
  instance_type = "t2.micro"

  tags = {
    Name = "Terraform-Instance-US-East-1"
  }

  depends_on = [aws_default_vpc.default_east]
}

resource "aws_instance" "west_server" {
  provider      = aws.us_west_2
  ami           = data.aws_ami.ubuntu_west.id
  instance_type = "t2.micro"

  tags = {
    Name = "Terraform-Instance-US-West-2"
  }

  depends_on = [aws_default_vpc.default_west]
}

output "us_east_1_instance_id" {
  value       = aws_instance.east_server.id
  description = "Instance ID in us-east-1"
}

output "us_west_2_instance_id" {
  value       = aws_instance.west_server.id
  description = "Instance ID in us-west-2"
}
