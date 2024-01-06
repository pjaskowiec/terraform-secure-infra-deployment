variable "lb_arn" {}
variable "lc_id" {}
variable "private_subnet_1_id" {}
variable "private_subnet_3_id" {}

resource "aws_autoscaling_policy" "web_app_scaling_policy" {
  name = "web-app-scaling-policy"
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    
    target_value = 60.0
  }
  
  autoscaling_group_name = aws_autoscaling_group.web_app_asg.name
}

resource "aws_autoscaling_group" "web_app_asg" {
  desired_capacity     = 2
  max_size             = 6
  min_size             = 2
  vpc_zone_identifier = [var.private_subnet_1_id, var.private_subnet_3_id]
  launch_configuration = var.lc_id  
  ignore_failed_scaling_activities = true
  force_delete = true
}

resource "aws_autoscaling_attachment" "asg_attachment_elb" {
  autoscaling_group_name = aws_autoscaling_group.web_app_asg.id
  lb_target_group_arn = var.lb_arn
}