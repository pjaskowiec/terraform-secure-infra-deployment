variable "key_name" {}
variable "security_group_id" {}
variable "public_subnet_1_id" {}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "bastion_host" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id = var.public_subnet_1_id
  key_name = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = "Bastion Host"
  }

  vpc_security_group_ids = [var.security_group_id]
}
