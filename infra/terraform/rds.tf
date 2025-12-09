resource "aws_db_subnet_group" "main" {
  name = "${local.project_name}-db-subnet-group"
  subnet_ids = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id,
  ]

  tags = {
    Name = "${local.project_name}-db-subnet-group"
  }
}

resource "aws_security_group" "db" {
  name        = "${local.project_name}-db-sg"
  description = "Allow Postgres access"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.project_name}-db-sg"
  }
}

resource "aws_db_instance" "postgres" {
  identifier        = "${local.project_name}-postgres"
  engine            = "postgres"
  engine_version    = "17.6"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  username = "orders_user"
  password = var.rds_password

  db_name              = "orders_db"
  db_subnet_group_name = aws_db_subnet_group.main.name
  skip_final_snapshot  = true
  publicly_accessible  = true

  vpc_security_group_ids = [aws_security_group.db.id]

  tags = {
    Name = "${local.project_name}-postgres"
  }
}

