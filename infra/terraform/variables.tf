variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "kafka-enterprise-orders"
}

variable "confluent_api_key" {
  description = "Confluent Cloud API key"
  type        = string
  sensitive   = true
}

variable "confluent_api_secret" {
  description = "Confluent Cloud API secret"
  type        = string
  sensitive   = true
}

variable "confluent_bootstrap_servers" {
  description = "Confluent Cloud bootstrap servers"
  type        = string
}

variable "rds_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

variable "container_image_producer" {
  description = "Docker image for order-producer"
  type        = string
  default     = "ghcr.io/nadi1993/kafka-enterprise-orders/order-producer:latest"
}

variable "container_image_payment" {
  description = "Docker image for payment-service"
  type        = string
  default     = "ghcr.io/nadi1993/kafka-enterprise-orders/payment-service:latest"
}

variable "container_image_fraud" {
  description = "Docker image for fraud-service"
  type        = string
  default     = "ghcr.io/nadi1993/kafka-enterprise-orders/fraud-service:latest"
}

variable "container_image_analytics" {
  description = "Docker image for analytics-service"
  type        = string
  default     = "ghcr.io/nadi1993/kafka-enterprise-orders/analytics-service:latest"
}

