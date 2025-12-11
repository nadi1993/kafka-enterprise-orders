resource "aws_secretsmanager_secret" "confluent_api" {
  name = "${var.project_name}-confluent-api-v2"
}

resource "aws_secretsmanager_secret_version" "confluent_api_v1" {
  secret_id     = aws_secretsmanager_secret.confluent_api.id
  secret_string = jsonencode({
    api_key    = var.confluent_api_key
    api_secret = var.confluent_api_secret
  })
}

resource "aws_secretsmanager_secret" "rds_credentials" {
  name = "${var.project_name}-rds-credentials-v2"
}

resource "aws_secretsmanager_secret_version" "rds_credentials_v1" {
  secret_id     = aws_secretsmanager_secret.rds_credentials.id
  secret_string = jsonencode({
    username = "postgres"
    password = var.rds_password
  })
}

