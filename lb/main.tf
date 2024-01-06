variable "lb_security_group_id" {}
variable "public_subnet_1_id" {}
variable "public_subnet_2_id" {}
variable "vpc_id" {}
variable "webhost_id" {}


resource "aws_lb_target_group" "lb_1_target_group" {
  name     = "lb-1-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold = 3 
    interval = 10
  }
}

resource "aws_lb" "lb-1" {
  name               = "lb-1"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.lb_security_group_id]
  subnets            = [var.public_subnet_1_id, var.public_subnet_2_id]

  enable_deletion_protection = false
}

resource "aws_lb_target_group_attachment" "lb_1_tg_attachment" {
  target_group_arn = aws_lb_target_group.lb_1_target_group.arn
  target_id        = var.webhost_id
  port             = 80
}

resource "aws_lb_listener" "webhost_listener" {
  load_balancer_arn = aws_lb.lb-1.arn
  port              = "80"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_1_target_group.arn
  }
}