variable "aws_region" {
  description = "AWS deployment region"
  type        = string
  default     = "ap-south-1" # Mumbai / Bengaluru region
}

variable "project_name" {
  description = "Project identifier"
  type        = string
  default     = "cloud-native-devsecops"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "devops-showcase-eks"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "production"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}
