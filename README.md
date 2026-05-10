# Guestbook DevOps Project

## 📌 Overview

This project demonstrates a production-style DevOps deployment pipeline using Terraform, Docker, AWS, and GitHub Actions.

The application is containerized using Docker and deployed automatically to AWS EC2 through a CI/CD pipeline.

---

# 🏗️ Architecture

GitHub → GitHub Actions → Amazon ECR → EC2 → Docker Container → CloudWatch

---

# ⚙️ Technologies Used

- Terraform
- AWS EC2
- AWS ECR
- Docker
- GitHub Actions
- CloudWatch
- Linux

---

# 🚀 Infrastructure Provisioning

Terraform provisions:

- EC2 Instance
- Security Group
- IAM Role
- IAM Instance Profile
- ECR Repository

---

# 🐳 Containerization

The application is containerized using Docker.

Build image:

```bash
docker build -t guestbook-app .
```

Run locally:

```bash
docker run -d -p 8080:8080 guestbook-app
```

---

# 🔄 CI/CD Pipeline

GitHub Actions pipeline automatically:

1. Builds Docker image
2. Pushes image to Amazon ECR
3. Connects to EC2
4. Pulls latest image
5. Deploys updated container

Pipeline file:

```text
.github/workflows/deploy.yml
```

---

# 📊 Monitoring & Logging

Amazon CloudWatch is used for:

- EC2 log monitoring
- System logs collection

---

# 🌐 Deployment

Application deployed on:

```text
http://54.144.153.85:8080
```

---

# 📂 Project Structure

```text
.
├── .github/workflows/
├── main.tf
├── variables.tf
├── outputs.tf
├── provider.tf
├── Dockerfile
├── README.md
```

---

# 📌 Assumptions

- AWS CLI configured
- Docker installed
- IAM permissions available
- GitHub secrets configured

---

# 🔧 Future Improvements

- Use ECS/EKS instead of EC2
- Add HTTPS with Load Balancer
- Add Terraform modules
- Add Kubernetes deployment
- Add Prometheus/Grafana monitoring

---

# 👩‍💻 Author

Queen Nnakwue