# Real-Time Orders Platform (Kafka + AWS)

This is a learning project where I built a real-time orders platform using an event-driven architecture and AWS cloud services.

The goal of this project was to practice DevOps and Cloud skills:
- Docker and containerization
- Kafka-based microservices
- Infrastructure as Code with Terraform
- Deployments to AWS (VPC, ECS Fargate, RDS)
- CI/CD with GitHub Actions

---

## Architecture Overview

**Microservices**

- `order-producer` – sends new orders into Kafka topics  
- `fraud-service` – checks orders for potential fraud  
- `payment-service` – processes payments  
- `analytics-service` – aggregates orders data for analytics

All services are packaged as Docker containers and communicate asynchronously using Kafka.

**Data Layer**

- PostgreSQL database running on **Amazon RDS**.

**Cloud Infrastructure (Terraform)**

Infrastructure is fully defined as code using Terraform:

- Custom **VPC** with CIDR `10.0.0.0/16`
- Two public subnets in different availability zones
- **Internet Gateway** and public route table
- **Security groups** for ECS tasks and RDS
- **RDS PostgreSQL** instance for application data
- **ECS Fargate cluster** for running the services
- ECS task definitions and services for:
  - `order-producer`
  - `fraud-service`
  - `payment-service`
  - `analytics-service`
- **CloudWatch log groups** for each service

Everything can be created and destroyed with Terraform.

---

## Infrastructure Deployment

> ⚠️ This project is for learning purposes. Running it in AWS may incur costs.

### Prerequisites

- AWS account
- Terraform installed locally
- AWS credentials configured (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`)
- Docker images for all services pushed to GitHub Container Registry (GHCR)

### Steps

```bash
# Clone the repository
git clone https://github.com/nadi1993/kafka-enterprise-orders.git
cd kafka-enterprise-orders/infra/terraform

# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply (create VPC, RDS, ECS, etc.)
terraform apply
