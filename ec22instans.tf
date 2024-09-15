provider "aws" {
  region     = "eu-north-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_instance" "EC2-Instance" {
  availability_zone      = "eu-north-1a"
  count                  = 1
  ami                    = "ami-0989fb15ce71ba39e"
  instance_type          = "t3.medium"
  key_name               = "Oleg"
  vpc_security_group_ids = [aws_security_group.tersec[count.index].id]

  ebs_block_device {
    device_name           = "/dev/sda1"
    volume_size           = 30
    volume_type           = "standard"
    delete_on_termination = true
    tags = {
      Name = "root-disk"
    }
  }
  user_data = file("./install.sh")
  tags = {
    Name = "EC2-Instance"
  }
}

resource "aws_security_group" "tersec" {
  count       = 2
  name        = "tersec-${count.index}"
  description = "uff - 165 social credit"

  dynamic "ingress" {
    for_each = ["80", "81", "443", "8080", "55555", "1433", "5034"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    description = "Allow 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow ping"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
