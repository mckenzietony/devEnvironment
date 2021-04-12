resource "aws_launch_configuration" "ecs_launch_config" {
  image_id             = "ami-05db638db4083f945"
  iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
  security_groups      = [aws_security_group.ecs_sg.id]
  user_data            = "#!/bin/bash\\ ECS_CLUSTER=trader-bois >> /etc/ecs/ecs.config"
  instance_type        = "m5zn.large"
  key_name             = "test-trader-nrt"
}

resource "aws_autoscaling_group" "ecs_asg" {
  name                 = "asg"
  vpc_zone_identifier  = [aws_subnet.pub_subnet.id]
  launch_configuration = aws_launch_configuration.ecs_launch_config.name

  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
}