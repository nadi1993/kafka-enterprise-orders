variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "us-west-2"
}

variable "project_name" {
  description = "Base name prefix for all resources"
  type        = string
  default     = "kafka-enterprise-orders-nadi-2025"
}

variable "confluent_api_key" {
  description = "Confluent Cloud API key"
  type        = string
  default     = ""
}

variable "confluent_api_secret" {
  description = "Confluent Cloud API secret"
  type        = string
  default     = ""
  sensitive   = true
}

variable "confluent_bootstrap_servers" {
  description = "Confluent Cloud bootstrap servers"
  type        = string
  default     = ""
}

variable "rds_password" {
  description = "Password for the RDS Postgres user"
  type        = string
  default     = "changeme-password"
  sensitive   = true
}

variable "container_image_producer" {
  description = "Docker image for the order producer service"
  type        = string
  default     = "ghcr.io/nadi1993/kafka-enterprise-orders/order-producer:latest"
}

variable "container_image_payment" {
  description = "Docker image for the payment service"
  type        = string
  default     = "ghcr.io/nadi1993/kafka-enterprise-orders/payment-service:latest"
}

variable "container_image_fraud" {
  description = "Docker image for the fraud service"
  type        = string
  default     = "ghcr.io/nadi1993/kafka-enterprise-orders/fraud-service:latest"
}

variable "container_image_analytics" {
  description = "Docker image for the analytics service"
  type        = string
  default     = "ghcr.io/nadi1993/kafka-enterprise-orders/analytics-service:latest"
}


variable "container_image_web_backend" {
  type        = string
  description = "Container image for web-backend (nginx serving React build)"
  default = "ghcr.io/nadi1993/kafka-enterprise-orders/frontend-nginx:latest"
}
