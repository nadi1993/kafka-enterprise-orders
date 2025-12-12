#################################
# web-backend (serves frontend via nginx)
#################################

resource "aws_cloudwatch_log_group" "web_backend" {
  name              = "/ecs/${local.project_name}-web-backend"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "web_backend" {
  family                   = "${local.project_name}-web-backend"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512

  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "web-backend"
      image     = "ghcr.io/nadi1993/kafka-enterprise-orders/frontend-nginx:latest"
      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.web_backend.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "web_backend" {
  name            = "${local.project_name}-web-backend-svc"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.web_backend.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.public_a.id, aws_subnet.public_b.id]
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.web_backend.arn
    container_name   = "web-backend"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.http]
}
