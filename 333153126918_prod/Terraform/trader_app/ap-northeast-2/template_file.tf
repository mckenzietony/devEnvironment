data "template_file" "task_definition_template" {
  template = file("task_definition.json.tpl")
  vars = {
    REPOSITORY_URL = "https://333153126918.dkr.ecr.ap-northeast-1.amazonaws.com/worker"
  }
}