variable "key_name" {}
variable "private_subnet_1_id" {}

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

resource "aws_instance" "web_app" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = var.private_subnet_1_id
  key_name      = var.key_name

  tags = {
    Name = "Web App Host"
  }
  user_data = <<EOF
#!/bin/bash
apt-get update
apt-get install -y mysql-server
service mysql start
echo -e "HTTP/1.1 200 OK\\nContent-type: text/html\\n\\n<h1>Hello from the web app on port 80</h1>" > /tmp/index.html
sudo python3 -m http.server 80 --directory /tmp
EOF
  vpc_security_group_ids = [aws_security_group.webapp_sg.id]
}

resource "aws_launch_configuration" "web_app_lc" {
  name = "web-app-lc"

  image_id = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = var.key_name

  user_data = <<EOF
#!/bin/bash
apt-get update
apt-get install -y mysql-server
service mysql start
echo -e "HTTP/1.1 200 OK\\nContent-type: text/html\\n\\n<h1>Hello from the web app on port 80</h1>" > /tmp/index.html
sudo python3 -m http.server 80 --directory /tmp
EOF

  security_groups = [aws_security_group.webapp_sg.id]
}
