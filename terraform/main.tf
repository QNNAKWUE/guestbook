locals {
  vpc_id = "vpc-02012d00c1b791802"
}

# ---------------- SUBNETS ----------------

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }
}

# ---------------- ECR ----------------

resource "aws_ecr_repository" "app_repo" {
  name = "guestbook-app"
}

# ---------------- KEY PAIR ----------------

resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

# ---------------- IAM ROLE ----------------

resource "aws_iam_role" "ec2_role" {
  name = "ec2-ecr-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# ---------------- SECURITY GROUP ----------------

resource "aws_security_group" "app_sg" {
  name        = "guestbook-sg"
  description = "Allow SSH and App Traffic"
  vpc_id      = local.vpc_id

  ingress {
    description = "SSH"

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Spring Boot App"

    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "guestbook-sg"
  }
}

# ---------------- EC2 INSTANCE ----------------

resource "aws_instance" "app_server" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"

  subnet_id = element(data.aws_subnets.default.ids, 0)

  vpc_security_group_ids = [
    aws_security_group.app_sg.id
  ]

  key_name = aws_key_pair.key.key_name

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  associate_public_ip_address = true

  tags = {
    Name = "guestbook-server"
  }

user_data = <<-EOF
#!/bin/bash
set -e

# Update system
yum update -y

# Install dependencies
yum install -y docker awscli
yum install -y amazon-cloudwatch-agent

# Start Docker
systemctl enable docker
systemctl start docker

# Add ec2-user to docker group
usermod -aG docker ec2-user

# Wait for Docker to fully start
sleep 10

# Login to ECR
aws ecr get-login-password --region us-east-1 \
| docker login --username AWS --password-stdin ${aws_ecr_repository.app_repo.repository_url}

# Pull latest image
docker pull ${aws_ecr_repository.app_repo.repository_url}:latest

# Stop old container if exists
docker stop app || true
docker rm app || true

# Run new container
docker run -d --name app -p 8080:8080 ${aws_ecr_repository.app_repo.repository_url}:latest

EOF
}

