resource "aws_launch_configuration" "ecs_launch_config" {
  image_id             = "ami-0beba7dd29d72a203"
  iam_instance_profile = "ecs-agent"
  security_groups      = [aws_security_group.ecs_sg.id]
  user_data_base64     = "IyEvYmluL2Jhc2gKCmVjaG8gRUNTX0NMVVNURVI9dHJhZGVyLWJvaXMgPj4gL2V0Yy9lY3MvZWNzLmNvbmZpZwoKeXVtIHVwZGF0ZSAteQp5dW0gaW5zdGFsbCAteSB5dW0tdXRpbHMKCiMgUmVnaXN0ZXIgdGhlIE1pY3Jvc29mdCBSZWRIYXQgcmVwb3NpdG9yeQpjdXJsIGh0dHBzOi8vcGFja2FnZXMubWljcm9zb2Z0LmNvbS9jb25maWcvcmhlbC83L3Byb2QucmVwbyB8IHN1ZG8gdGVlIC9ldGMveXVtLnJlcG9zLmQvbWljcm9zb2Z0LnJlcG8KCiMgSW5zdGFsbCBQb3dlclNoZWxsCnl1bSBpbnN0YWxsIHBvd2Vyc2hlbGwgLXkKCiMgQWxsb3cgYWNjZXNzIHVzaW5nIHBvd2Vyc2hlbGwKZWNobyAiICAiID4+IC9ldGMvc3NoL3NzaGRfY29uZmlnCmVjaG8gIiMgUG93ZXJzaGVsbCBTdWJzeXN0ZW0gLS0gQWxsb3cgcHdzaCByZW1vdGluZyIgPj4gL2V0Yy9zc2gvc3NoZF9jb25maWcKZWNobyAiU3Vic3lzdGVtIHBvd2Vyc2hlbGwgL3Vzci9iaW4vcHdzaCAtc3NocyAtTm9Mb2dvIiA+PiAvZXRjL3NzaC9zc2hkX2NvbmZpZwoKZWNobyAic3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUNPdDRaQk04dUFnN1NrVmo0aDZpdzRkc1NQUmFDNGJnK2NtNDhNNGhWbXIgdG1ja2VuemllQHZlc3V2aXVzIiA+PiAvaG9tZS9lYzItdXNlci8uc3NoL2F1dGhvcml6ZWRfa2V5cwplY2hvICJzc2gtcnNhIEFBQUFCM056YUMxeWMyRUFBQUFEQVFBQkFBQUJBUUN6ekxja2FlT05XTjZpRkQ0QVY0c05zZllodkxVRUlFUE5jWndobFdCSWpNZndENGxWbytrN1owdWVyMjcyZVhUT1VkNUQ2Q1ZOMXd0SzR5d3BPR2JKRUZkZnJxSHhWZTQwNXZodmF0SEExRkpJN2tNOEd6NXNJejJIY1ZlYlcyaGxUdjJ4bWlwYmdsZUVxNFlSQWY1SmNMNnM1NkUrT0crYmZFcTlwUUQxSDJzYk1CcnErb3h4QTVNL2lhZSt0MmV2VFU4T1Rmb1loTlgwRnYzSDNzYmtDSWoxWUdHd0lIakFsU2s0NkVHR0NkWUF2UHlPRGtEZndoUjZjTXQxMEM1ekdHNUx3NTBkZWpHVjRObGwwbndacHlnYnJyRVl3L3JiQVZ5VSt1bnI2U25hUFdrRis5UUNJcDBrU0ZmQXR6cjJWZjFZZDlabVRKUGxzZTVkMXlvdiBqYW1lcy10ZXN0LWtleS1ucnQiID4+IC9ob21lL2VjMi11c2VyLy5zc2gvYXV0aG9yaXplZF9rZXlzCnN5c3RlbWN0bCByZXN0YXJ0IHNzaGQ="
  instance_type        = "m5d.xlarge"
  key_name             = "prod-trader-itm"
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