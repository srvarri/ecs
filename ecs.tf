# Create ECS task definition for Nginx service
resource "aws_ecs_task_definition" "nginx" {
  family = "nginx"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  container_definitions = jsonencode([
    {
      name      = "first"
      image     = "tejaaws/nginx:latest"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
 ])
}

# # Create ECS service for Nginx
resource "aws_ecs_service" "my_service" {
  name            = "nginxservice"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.nginx.arn
  desired_count   = 1
  launch_type = "FARGATE"
  platform_version = "LATEST"
  scheduling_strategy = "REPLICA"
  force_new_deployment = true

  network_configuration {
    assign_public_ip = true
    subnets          = [aws_subnet.public.id]
    security_groups  = [aws_security_group.sgroup.id]
  }
  lifecycle {
    ignore_changes = [
      task_definition
    ]
  }
}