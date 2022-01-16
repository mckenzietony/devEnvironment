resource "aws_launch_configuration" "ecs_launch_config" {
  image_id             = "ami-0bb691c8777365c0f"
  iam_instance_profile = "ecs-agent"
  security_groups      = [aws_security_group.ecs_sg.id]
  user_data_base64     = "IyEvYmluL2Jhc2gKCmVjaG8gRUNTX0NMVVNURVI9dHJhZGVyLWJvaXMgPj4gL2V0Yy9lY3MvZWNzLmNvbmZpZwoKeXVtIHVwZGF0ZSAteQp5dW0gaW5zdGFsbCAteSB5dW0tdXRpbHMKCiMgUmVnaXN0ZXIgdGhlIE1pY3Jvc29mdCBSZWRIYXQgcmVwb3NpdG9yeQpjdXJsIGh0dHBzOi8vcGFja2FnZXMubWljcm9zb2Z0LmNvbS9jb25maWcvcmhlbC83L3Byb2QucmVwbyB8IHN1ZG8gdGVlIC9ldGMveXVtLnJlcG9zLmQvbWljcm9zb2Z0LnJlcG8KCiMgSW5zdGFsbCBQb3dlclNoZWxsCnl1bSBpbnN0YWxsIHBvd2Vyc2hlbGwgLXkKCiMgQWxsb3cgYWNjZXNzIHVzaW5nIHBvd2Vyc2hlbGwKZWNobyAiICAiID4+IC9ldGMvc3NoL3NzaGRfY29uZmlnCmVjaG8gIiMgUG93ZXJzaGVsbCBTdWJzeXN0ZW0gLS0gQWxsb3cgcHdzaCByZW1vdGluZyIgPj4gL2V0Yy9zc2gvc3NoZF9jb25maWcKZWNobyAiU3Vic3lzdGVtIHBvd2Vyc2hlbGwgL3Vzci9iaW4vcHdzaCAtc3NocyAtTm9Mb2dvIiA+PiAvZXRjL3NzaC9zc2hkX2NvbmZpZwoKZWNobyAic3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUNPdDRaQk04dUFnN1NrVmo0aDZpdzRkc1NQUmFDNGJnK2NtNDhNNGhWbXIgdG1ja2VuemllQHZlc3V2aXVzIiA+PiAvaG9tZS9lYzItdXNlci8uc3NoL2F1dGhvcml6ZWRfa2V5cwplY2hvICJzc2gtcnNhIFxuQUFBQUIzTnphQzF5YzJFQUFBQURBUUFCQUFBQkFRQ3p6TGNrYWVPTldONmlGRDRBVjRzTnNmWWh2TFVFSUVQTmNad2hsV0JJak1md0Q0bFZvK2s3WjB1ZXIyNzJlWFRPVWQ1RDZDVk4xd3RLNHl3cE9HYkpFRmRmcnFIeFZlNDA1dmh2YXRIQTFGSkk3a004R3o1c0l6MkhjVmViVzJobFR2MnhtaXBiZ2xlRXE0WVJBZjVKY0w2czU2RStPRytiZkVxOXBRRDFIMnNiTUJycStveHhBNU0vaWFlK3QyZXZUVThPVGZvWWhOWDBGdjNIM3Nia0NJajFZR0d3SUhqQWxTazQ2RUdHQ2RZQXZQeU9Ea0Rmd2hSNmNNdDEwQzV6R0c1THc1MGRlakdWNE5sbDBud1pweWdicnJFWXcvcmJBVnlVK3VucjZTbmFQV2tGKzlRQ0lwMGtTRmZBdHpyMlZmMVlkOVptVEpQbHNlNWQxeW92XG4gamFtZXMtdGVzdC1rZXktbnJ0IiA+PiAvaG9tZS9lYzItdXNlci8uc3NoL2F1dGhvcml6ZWRfa2V5cwpzeXN0ZW1jdGwgcmVzdGFydCBzc2hk"
  instance_type        = "z1d.metal"
  key_name             = "prod-trader-icn"
}

resource "aws_autoscaling_group" "ecs_asg" {
  name                 = "asg"
  vpc_zone_identifier  = [aws_subnet.pub_subnet.id]
  launch_configuration = aws_launch_configuration.ecs_launch_config.name

  desired_capacity          = 0
  min_size                  = 0
  max_size                  = 0
  health_check_grace_period = 300
  health_check_type         = "EC2"
}
