resource "aws_ecs_task_definition" "task_definition" {
  family = "worker"
  execution_role_arn = "arn:aws:iam::333153126918:role/ecs-agent"
  container_definitions = data.template_file.task_definition_template.rendered
}
