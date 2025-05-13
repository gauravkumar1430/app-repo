#cloud provider
provider "aws" {
    region = "us-east-1"
  
}

#vpc
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    tags = { 
        Name = "app-vpc"
    }
  
}

#public Subnet
resource "aws_subnet" "public" {
    count = 2
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.${count.index + 1}.0/24"
    availability_zone = element(["us-east-1a", "us-east-1b"], count.index)
    tags = {
        Name = "public-subnet-${count.index + 1}"
    }
  
}
#DB subnet Group
resource "aws_db_subnet_group" "main" {
    name = "app-db-subnet-group"
    subnet_ids = aws_subnet.public[*].id
    tags = {
        Name = "app-db-subnet-group"
    }
  
}

#eks Cluster
resource "aws_eks_cluster" "app_cluster" {
    name = "app-eks-cluster"
    role_arn = aws_iam_role.eks_role.arn
    vpc_config {
      subnet_ids = aws_subnet.public[*].id
    }
  
}

#RDS Instance
resource "aws_db_instance" "app-db" {
    identifier = "app-db"
    engine = "postgres"
    instance_class = "db.t3.micro"
    allocated_storage = 20
    username = "appuser"
    password = var.db_password
    vpc_security_group_ids = [aws_security_group.rds_sg.id]
    db_subnet_group_name = aws_db_subnet_group.main.name
    skip_final_snapshot = true
  
}

#Security Group for RDS
resource "aws_security_group" "rds_sg" {
    vpc_id = aws_vpc.main.id
    ingress {
        from_port = 5432
        to_port = 5432
        protocol = "tcp"
        cidr_blocks = ["10.0.0.0/16"]
    }
  
}

#IAM fors for EKS
resource "aws_iam_role" "eks_role" {
    name = "eks-cluster-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = { Service = "eks.amazonaws.com"}
        }]
    })
  
}