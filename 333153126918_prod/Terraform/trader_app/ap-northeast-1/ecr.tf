resource "aws_ecr_repository" "worker" {
  name = "worker"
  
  image_scanning_configuration {
    scan_on_push = true
  }
}