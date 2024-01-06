output "lb_id" {
    value = aws_lb.lb-1.id
}

output "lb_arn" {
    value = aws_lb_target_group.lb_1_target_group.arn
}
