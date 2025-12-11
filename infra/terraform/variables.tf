variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-2"
}

variable "project_name" {
  description = "Base name used for all resources"
  type        = string
  default     = "kafka-enterprise-orders-nadi-2025"
}

variable "confluent_api_key" {
  description = "Confluent Cloud API key"
  type        = string
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
  description = "Password for RDS PostgreSQL"
  type        = string
  sensitive   = true
}

variable "container_image_producer" {
  description = "Container image for order producer service"
  type        = string
}

variable "container_image_payment" {
  description = "Container image for payment service"
  type        = string
}

variable "container_image_fraud" {
  description = "Container image for fraud service"
  type        = string
}

variable "container_image_analytics" {
  description = "Container image for analytics service"
  type        = string
}

