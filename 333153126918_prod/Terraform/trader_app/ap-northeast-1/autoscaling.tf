resource "aws_launch_configuration" "ecs_launch_config" {
  image_id             = "ami-0ad5a3959c516f3a5"
  iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
  security_groups      = [aws_security_group.ecs_sg.id]
  user_data_base64     = "IyEvYmluL2Jhc2gKCmVjaG8gRUNTX0NMVVNURVI9dHJhZGVyLWJvaXMgPj4gL2V0Yy9lY3MvZWNzLmNvbmZpZwoKeXVtIHVwZGF0ZSAteQp5dW0gaW5zdGFsbCAteSB5dW0tdXRpbHMKCiMgUmVnaXN0ZXIgdGhlIE1pY3Jvc29mdCBSZWRIYXQgcmVwb3NpdG9yeQpjdXJsIGh0dHBzOi8vcGFja2FnZXMubWljcm9zb2Z0LmNvbS9jb25maWcvcmhlbC83L3Byb2QucmVwbyB8IHN1ZG8gdGVlIC9ldGMveXVtLnJlcG9zLmQvbWljcm9zb2Z0LnJlcG8KCiMgSW5zdGFsbCBQb3dlclNoZWxsCnl1bSBpbnN0YWxsIHBvd2Vyc2hlbGwgLXkKCiMgQWxsb3cgYWNjZXNzIHVzaW5nIHBvd2Vyc2hlbGwKZWNobyAiICAiID4+IC9ldGMvc3NoL3NzaGRfY29uZmlnCmVjaG8gIiMgUG93ZXJzaGVsbCBTdWJzeXN0ZW0gLS0gQWxsb3cgcHdzaCByZW1vdGluZyIgPj4gL2V0Yy9zc2gvc3NoZF9jb25maWcKZWNobyAiU3Vic3lzdGVtIHBvd2Vyc2hlbGwgL3Vzci9iaW4vcHdzaCAtc3NocyAtTm9Mb2dvIiA+PiAvZXRjL3NzaC9zc2hkX2NvbmZpZwoKZWNobyAic3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUNPdDRaQk04dUFnN1NrVmo0aDZpdzRkc1NQUmFDNGJnK2NtNDhNNGhWbXIgdG1ja2VuemllQHZlc3V2aXVzIiA+PiAvaG9tZS9lYzItdXNlci8uc3NoL2F1dGhvcml6ZWRfa2V5cwplY2hvICJzc2gtcnNhIEFBQUFCM056YUMxeWMyRUFBQUFEQVFBQkFBQUJBUUN6ekxja2FlT05XTjZpRkQ0QVY0c05zZllodkxVRUlFUE5jWndobFdCSWpNZndENGxWbytrN1owdWVyMjcyZVhUT1VkNUQ2Q1ZOMXd0SzR5d3BPR2JKRUZkZnJxSHhWZTQwNXZodmF0SEExRkpJN2tNOEd6NXNJejJIY1ZlYlcyaGxUdjJ4bWlwYmdsZUVxNFlSQWY1SmNMNnM1NkUrT0crYmZFcTlwUUQxSDJzYk1CcnErb3h4QTVNL2lhZSt0MmV2VFU4T1Rmb1loTlgwRnYzSDNzYmtDSWoxWUdHd0lIakFsU2s0NkVHR0NkWUF2UHlPRGtEZndoUjZjTXQxMEM1ekdHNUx3NTBkZWpHVjRObGwwbndacHlnYnJyRVl3L3JiQVZ5VSt1bnI2U25hUFdrRis5UUNJcDBrU0ZmQXR6cjJWZjFZZDlabVRKUGxzZTVkMXlvdiBqYW1lcy10ZXN0LWtleS1ucnQiID4+IC9ob21lL2VjMi11c2VyLy5zc2gvYXV0aG9yaXplZF9rZXlzCmVjaG8gInNzaC1lZDI1NTE5IEFBQUFDM056YUMxbFpESTFOVEU1QUFBQUlLR0tiSjZIdUR6NWlpWTI0cWkxdkN4OGxNSTkveG1lSnJSOWtxTENJTmlwIGphbWVzQGNhbnRvciIgPj4gL2hvbWUvZWMyLXVzZXIvLnNzaC9hdXRob3JpemVkX2tleXMKZWNobyAic3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUxFaW45c2xwUW9qK2hFQ09QckZUZFFLdTUxNldiMUVtU051STZ1elowRFggamFtZXNAbGFwbGFjZSIgPj4gL2hvbWUvZWMyLXVzZXIvLnNzaC9hdXRob3JpemVkX2tleXMKZWNobyAic3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUtHS2JKNkh1RHo1aWlZMjRxaTF2Q3g4bE1JOS94bWVKclI5a3FMQ0lOaXAgamFtZXNAY2FudG9yIiA+PiAvaG9tZS9lYzItdXNlci8uc3NoL2F1dGhvcml6ZWRfa2V5cwpzeXN0ZW1jdGwgcmVzdGFydCBzc2hkCgojIEZvcmNlIHB1bGwgdGhlIGltYWdlIHRvIGNvbmZpcm0gd2UgYXJlbid0IHdhaXRpbmcgZm9yIGVjcyB0byBxdWV1ZSB1cCAtLQojIFRPRE8gaW52ZXN0aWdhdGUgd2h5IGVjcyBzb21ldGltZXMgdGFrZXMgYSB3aGlsZSB0byBncmFiIHRoZSBuZXcgZG9ja2VyIGltYWdlCnl1bSBpbnN0YWxsIGF3c2NsaSAteQphd3MgZWNyIGdldC1sb2dpbi1wYXNzd29yZCAtLXJlZ2lvbiBhcC1ub3J0aGVhc3QtMSB8IGRvY2tlciBsb2dpbiAtLXVzZXJuYW1lIEFXUyAtLXBhc3N3b3JkLXN0ZGluIDMzMzE1MzEyNjkxOC5ka3IuZWNyLmFwLW5vcnRoZWFzdC0xLmFtYXpvbmF3cy5jb20KZG9ja2VyIHB1bGwgMzMzMTUzMTI2OTE4LmRrci5lY3IuYXAtbm9ydGhlYXN0LTEuYW1hem9uYXdzLmNvbS93b3JrZXI6bGF0ZXN0Cg=="
  instance_type        = "z1d.metal"
  key_name             = "prod-trader-nrt"
}

resource "aws_autoscaling_group" "ecs_asg" {
  name = "asg"
  vpc_zone_identifier = [
    aws_subnet.pub_subnet_a.id,
    aws_subnet.pub_subnet_c.id
  ]
  launch_configuration = aws_launch_configuration.ecs_launch_config.name

  desired_capacity          = 0
  min_size                  = 0
  max_size                  = 3
  health_check_grace_period = 300
  health_check_type         = "EC2"
  tags = [
    {
      "key"                 = "Name"
      "value"               = "trader-app"
      "propagate_at_launch" = true
    },
    {
      "key"                 = "IsProd"
      "value"               = "yes"
      "propagate_at_launch" = true
    }
  ]
}
