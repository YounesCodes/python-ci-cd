terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
    region = "eu-north-1"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

data "aws_iam_role" "SSMAccess" {
  name = "SSMAccess"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ssm-access-profile"
  role = data.aws_iam_role.SSMAccess.name
}


resource "aws_instance" "app" {
    ami = data.aws_ssm_parameter.al2023.value # get latest 
    instance_type = "t3.micro"
    iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
    key_name = "python-ci-cd"
    
    ebs_optimized = true 
    monitoring = true 

    vpc_security_group_ids = [aws_security_group.app_sg.id]

    root_block_device {
      encrypted = true
    }

    metadata_options {
      http_tokens = "required"
    }

    user_data = <<-EOF
                #!/bin/bash
                set -e

                # Install Docker if not present
                if ! command -v docker &> /dev/null; then
                    yum update -y
                    yum install docker -y
                    systemctl enable docker
                    systemctl start docker
                    usermod -aG docker ec2-user
                fi
                EOF

    tags = {
        Name = "python-ci-cd"
    }

}

resource "aws_eip" "app_eip" {
  domain = "vpc"
}

resource "aws_eip_association" "app_assoc" {
    instance_id = aws_instance.app.id
    allocation_id = aws_eip.app_eip.id
}

resource "aws_security_group" "app_sg" {

    #checkov:skip=CKV_AWS_23: "skip"
    #checkov:skip=CKV_AWS_382: "skip"
    #checkov:skip=CKV_AWS_260: "skip"

    name = "app_sg"
    description = "HTTP + SSH"
    vpc_id = data.aws_vpc.default.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
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

output "public_dns" {
    value = aws_eip.app_eip.public_dns
}