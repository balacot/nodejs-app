resource "aws_ecs_cluster" "nodejs_cluster" {
  name = "${var.project_name}-cluster"
}

resource "aws_ecs_task_definition" "nodejs_task" {
  family                   = "${var.project_name}-task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.codebuild_role.arn

  container_definitions = jsonencode([
    {
      name      = "nodejs-container"
      image     = "${aws_ecr_repository.nodejs_app.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "nodejs_service" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.nodejs_cluster.id
  task_definition = aws_ecs_task_definition.nodejs_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnet_ids
    assign_public_ip = true
    security_groups = [aws_security_group.ecs_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.nodejs_tg.arn
    container_name   = "nodejs-container"
    container_port   = var.container_port
  }

  depends_on = [
    aws_lb_listener.http_listener
  ]
}
