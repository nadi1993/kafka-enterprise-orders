data "aws_iam_policy_document" "grafana_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "SERVICE"
      identifiers = ["grafana.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "grafana_role" {
  name               = "${var.project_name}-grafana-role"
  assume_role_policy = data.aws_iam_policy_document.grafana_assume.json
}

data "aws_iam_policy_document" "grafana_policy" {
  statement {
    effect = "Allow"
    actions = [
      "aps:QueryMetrics",
      "aps:GetSeries",
      "aps:GetLabels",
      "aps:GetMetricMetadata"
    ]
    resources = [
      aws_prometheus_workspace.main.arn,
      "${aws_prometheus_workspace.main.arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "cloudwatch:GetMetricData",
      "cloudwatch:ListMetrics",
      "logs:GetLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "grafana_policy" {
  name   = "${var.project_name}-grafana-policy"
  policy = data.aws_iam_policy_document.grafana_policy.json
}

resource "aws_iam_role_policy_attachment" "grafana_attach" {
  role       = aws_iam_role.grafana_role.name
  policy_arn = aws_iam_policy.grafana_policy.arn
}

resource "aws_grafana_workspace" "main" {
  name                     = "${var.project_name}-grafana"
  account_access_type      = "CURRENT_ACCOUNT"
  authentication_providers = ["AWS_SSO"]
  permission_type          = "SERVICE_MANAGED"

  role_arn = aws_iam_role.grafana_role.arn

  data_sources = [
    "CLOUDWATCH",
    "PROMETHEUS"
  ]
}

