# Guestbook DevOps Deployment (AWS + Terraform + Docker + CI/CD)
## Overview

This project demonstrates a complete DevOps pipeline for deploying a Spring Boot Guestbook application on AWS. It tdemonstrates end-to-end DevOps automation including infrastructure provisioning, CI/CD pipeline, containerization, and cloud deployment on AWS.

The system includes:
- Infrastructure provisioning using Terraform
- Docker containerization of the application
- CI/CD pipeline using GitHub Actions
- Deployment to AWS EC2
- Image storage in Amazon ECR
- Logging using AWS CloudWatch


## Architecture

User → Browser → EC2 Instance (Spring Boot App in Docker)  
                     ↓  
                   Amazon ECR (Docker Images)  
                     ↓  
             GitHub Actions (CI/CD Pipeline)  
                     ↓  
             Terraform (Infrastructure)  
                     ↓  
         CloudWatch Logs (Monitoring)



## Tech Stack

- AWS EC2
- AWS ECR
- AWS CloudWatch
- Terraform
- Docker
- GitHub Actions
- Spring Boot (Java 21)


## Infrastructure as Code

Terraform is used to provision:
- EC2 instance
- Security Group (ports 22, 8080)
- IAM Role for EC2 (ECR + CloudWatch permissions)
- ECR repository for Docker images
- Key pair for SSH access


terraform/
  ├── main.tf
  ├── variables.tf
  ├── outputs.tf
  ├── provider.tf


## CI/CD Pipeline (GitHub Actions)

The pipeline performs:

1. Build application using Maven
2. Run tests
3. Build Docker image
4. Push image to Amazon ECR
5. SSH into EC2 instance
6. Pull latest image and redeploy container


## Workflow file

.github/workflows/deploy.yml


## Deployment Steps

### 1. Clone repository
git clone <repo-url>

### 2. Deploy infrastructure
- cd terraform
- terraform init
- terraform apply

### 3. Push code to GitHub main branch

This triggers GitHub Actions pipeline automatically.

### 4. Pipeline executes:
- Builds JAR file
- Builds Docker image
- Pushes image to ECR
- Deploys to EC2 via SSH

### 5. Access application
http://<EC2_PUBLIC_IP>:8080/guestbook


## Containerization

The application is containerized using Docker.

### Build command:
docker build -t guestbook-app .

### Run command:
docker run -p 8080:8080 guestbook-app


## Monitoring & Logging

AWS CloudWatch Agent is installed on EC2 to collect logs.

### Logs collected:
- /var/log/messages

### Log group:
guestbook

### Log stream:
ec2


## Design Decisions

- EC2 chosen for simplicity and cost efficiency
- Docker used for consistent deployment environment
- GitHub Actions used instead of Jenkins for faster setup
- Terraform used to ensure reproducible infrastructure


## Assumptions

- AWS credentials are configured in GitHub Secrets
- EC2 has internet access to pull from ECR
- Port 8080 is open in security group


## Limitations

- No auto-scaling group implemented
- Single EC2 instance (no high availability)
- No database persistence layer (in-memory HSQLDB)


## Future Improvements

- Move to ECS or EKS for production-grade deployment
- Add Application Load Balancer (ALB)
- Add database (RDS)
- Add rollback strategy in CI/CD
- Improve monitoring dashboards in CloudWatch

## Key Notes

- AWS credentials are configured in GitHub Secrets
- EC2 has internet access to pull from ECR
- Port 8080 is open in security group


## Repository Structure


├── terraform/
├── .github/workflows/
├── src/
├── Dockerfile
├── pom.xml
└── README.md