# -> Postgresql datbase instance 
resource "aws_db_instance" "rds" {
  identifier              = "${var.db_identifier}-${var.environment}"
  instance_class          = var.db_instance_class
  engine                  = "postgres"
  engine_version          = var.db_engine_version
  username                = var.db_username
  password                = var.db_password
  db_name                 = var.db_name
  db_subnet_group_name    = aws_db_subnet_group.rds.name
  vpc_security_group_ids  = [aws_security_group.rds.id]
  parameter_group_name    = aws_db_parameter_group.rds_params.name
  allocated_storage       = 10
  backup_retention_period = 1
  publicly_accessible     = false
  skip_final_snapshot     = true
}

# -> db read replica 
resource "aws_db_instance" "replica" {
  replicate_source_db    = aws_db_instance.rds.identifier
  identifier             = "${var.db_identifier}-${var.environment}-replica"
  instance_class         = var.db_instance_class
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.rds_params.name
  skip_final_snapshot    = true
}

# -> db parans 
resource "aws_db_parameter_group" "rds_params" {
  name   = "psql-db-params"
  family = "postgres17"
  parameter {
    name  = "log_connections"
    value = "1"
  }
}

# -> rds databse subnet*s 
resource "aws_db_subnet_group" "rds" {
  name       = "${var.db_identifier}-${var.environment}-subnet"
  subnet_ids = var.db_subnet_ids

}


# -> security group for the database
resource "aws_security_group" "rds" {
  name   = "${var.db_identifier}-${var.environment}-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidr_blocks
  }
}