resource "aws_launch_configuration" "ecs_launch_config" {
  image_id             = "ami-05db638db4083f945"
  iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
  security_groups      = [aws_security_group.ecs_sg.id]
  user_data_base64     = "IyEvYmluL2Jhc2gNCg0KZWNobyBFQ1NfQ0xVU1RFUj10cmFkZXItYm9pcyA+PiAvZXRjL2Vjcy9lY3MuY29uZmlnDQoNCnl1bSB1cGRhdGUgLXkNCnl1bSBpbnN0YWxsIC15IHl1bS11dGlscw0KDQojIFJlZ2lzdGVyIHRoZSBNaWNyb3NvZnQgUmVkSGF0IHJlcG9zaXRvcnkNCmN1cmwgaHR0cHM6Ly9wYWNrYWdlcy5taWNyb3NvZnQuY29tL2NvbmZpZy9yaGVsLzcvcHJvZC5yZXBvIHwgc3VkbyB0ZWUgL2V0Yy95dW0ucmVwb3MuZC9taWNyb3NvZnQucmVwbw0KDQojIEluc3RhbGwgUG93ZXJTaGVsbA0KeXVtIGluc3RhbGwgcG93ZXJzaGVsbCAteQ0KDQojIEFsbG93IGFjY2VzcyB1c2luZyBwb3dlcnNoZWxsDQplY2hvICIgICIgPj4gL2V0Yy9zc2gvc3NoZF9jb25maWcNCmVjaG8gIiMgUG93ZXJzaGVsbCBTdWJzeXN0ZW0gLS0gQWxsb3cgcHdzaCByZW1vdGluZyIgPj4gL2V0Yy9zc2gvc3NoZF9jb25maWcNCmVjaG8gIlN1YnN5c3RlbSBwb3dlcnNoZWxsIC91c3IvYmluL3B3c2ggLXNzaHMgLU5vTG9nbyIgPj4gL2V0Yy9zc2gvc3NoZF9jb25maWcNCnN5c3RlbWN0bCByZXN0YXJ0IHNzaGQ="
  instance_type        = "m5zn.large"
  key_name             = "test-trader-nrt"
}

resource "aws_autoscaling_group" "ecs_asg" {
  name                 = "asg"
  vpc_zone_identifier  = [aws_subnet.pub_subnet.id]
  launch_configuration = aws_launch_configuration.ecs_launch_config.name

  desired_capacity          = 0
  min_size                  = 0
  max_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
}