output "webhost_id" {
    value = aws_instance.web_app.id
}

output "lc_id" {
    value = aws_launch_configuration.web_app_lc.id
}

output "db_security_group" {
    value = aws_security_group.db_security_group.id
}