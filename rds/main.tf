variable "private_subnet_1_id" {}
variable "private_subnet_3_id" {}
variable "db_security_group" {}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = [var.private_subnet_1_id, var.private_subnet_3_id]

  tags = {
    Name = "db-subnet-group"
  }
}

resource "aws_db_instance" "webapp-db" {
  identifier           = "webapp-db"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql" 
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  # powinno byc z enva, ale już nie mam sily:)
  db_name              = "WebappDB"
  username             = "admin"
  password             = "dummy123"
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [var.db_security_group]
  skip_final_snapshot = true

  tags = {
    Name = "webapp-db"
  }
}
