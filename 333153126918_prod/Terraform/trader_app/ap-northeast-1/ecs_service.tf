resource "aws_ecs_service" "worker" {
  name            = "worker"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1
  network_configuration {
    subnets = [
      aws_subnet.pub_subnet_a.id,
      aws_subnet.pub_subnet_c.id,
      aws_subnet.pub_subnet_d.id,
    ]
  }
}

