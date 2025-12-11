#################################
# ECS Cluster
#################################

resource "aws_ecs_cluster" "this" {
  name = "${local.project_name}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "${local.project_name}-ecs-cluster"
  }
}

#################################
# IAM Roles for ECS Tasks
#################################

resource "aws_iam_role" "ecs_task_execution" {
  name = "${local.project_name}-ecs-task-execution"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_role" {
  name = "${local.project_name}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

#################################
# Security Group for ECS Tasks
#################################

resource "aws_security_group" "ecs_tasks" {
  name        = "${local.project_name}-ecs-tasks-sg"
  description = "Allow ECS tasks outbound internet"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.project_name}-ecs-tasks-sg"
  }
}

#################################
# order-producer
#################################

resource "aws_cloudwatch_log_group" "order_producer" {
  name              = "/ecs/${local.project_name}-order-producer"
  retention_in_days = 7

  tags = {
    Name = "${local.project_name}-order-producer-logs"
  }
}

resource "aws_ecs_task_definition" "order_producer" {
  family                   = "${local.project_name}-order-producer"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512

  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "order-producer"
      image     = var.container_image_producer
      essential = true

      environment = [
        { name = "KAFKA_BROKER", value = var.confluent_bootstrap_servers },
        { name = "CONFLUENT_API_KEY", value = var.confluent_api_key },
        { name = "CONFLUENT_API_SECRET", value = var.confluent_api_secret }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.order_producer.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

resource "aws_ecs_service" "order_producer" {
  name            = "${local.project_name}-order-producer-svc"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.order_producer.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.public_a.id, aws_subnet.public_b.id]
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}

#################################
# fraud-service
#################################

resource "aws_cloudwatch_log_group" "fraud_service" {
  name              = "/ecs/${local.project_name}-fraud-service"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "fraud_service" {
  family                   = "${local.project_name}-fraud-service"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "fraud-service"
      image     = var.container_image_fraud
      essential = true

      environment = [
        { name = "KAFKA_BROKER", value = var.confluent_bootstrap_servers },
        { name = "ORDERS_TOPIC", value = "orders" },
        { name = "FRAUD_ALERTS_TOPIC", value = "fraud-alerts" }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.fraud_service.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "fraud_service" {
  name            = "${local.project_name}-fraud-service-svc"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.fraud_service.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.public_a.id, aws_subnet.public_b.id]
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}

#################################
# payment-service
#################################

resource "aws_cloudwatch_log_group" "payment_service" {
  name              = "/ecs/${local.project_name}-payment-service"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "payment_service" {
  family                   = "${local.project_name}-payment-service"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "payment-service"
      image     = var.container_image_payment
      essential = true

      environment = [
        { name = "KAFKA_BROKER", value = var.confluent_bootstrap_servers },
        { name = "ORDERS_TOPIC", value = "orders" },
        { name = "PAYMENTS_TOPIC", value = "payments" }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.payment_service.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "payment_service" {
  name            = "${local.project_name}-payment-service-svc"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.payment_service.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.public_a.id, aws_subnet.public_b.id]
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}
#################################
# analytics-service
#################################

# CloudWatch logs for analytics-service
resource "aws_cloudwatch_log_group" "analytics_service" {
  name              = "/ecs/${local.project_name}-analytics-service"
  retention_in_days = 7

  tags = {
    Name = "${local.project_name}-analytics-service-logs"
  }
}

# ECS task definition for analytics-service
resource "aws_ecs_task_definition" "analytics_service" {
  family                   = "${local.project_name}-analytics-service"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "analytics-service"
      image     = var.container_image_analytics
      essential = true

      environment = [
        { name = "KAFKA_BROKER", value = var.confluent_bootstrap_servers },
        { name = "PAYMENTS_TOPIC", value = "payments" },
        { name = "POSTGRES_HOST", value = aws_db_instance.postgres.address },
        { name = "POSTGRES_DB", value = "orders_db" },
        { name = "POSTGRES_USER", value = "orders_user" },
        { name = "POSTGRES_PASSWORD", value = var.rds_password }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.analytics_service.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

# ECS service for analytics-service
resource "aws_ecs_service" "analytics_service" {
  name            = "${local.project_name}-analytics-service-svc"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.analytics_service.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.public_a.id, aws_subnet.public_b.id]
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}

