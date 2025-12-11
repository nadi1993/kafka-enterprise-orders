terraform {
  backend "s3" {
    bucket = "kafka-enterprise-orders-tfstate-nadi-west-2"
    key    = "infra/terraform.tfstate"
    region = "us-west-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

