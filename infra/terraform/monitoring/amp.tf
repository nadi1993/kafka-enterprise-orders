resource "aws_prometheus_workspace" "main" {
  alias = "${var.project_name}-amp"
}

