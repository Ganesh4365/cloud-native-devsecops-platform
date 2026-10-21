# S3 Remote State Backend Configuration
# To use: create an S3 bucket and DynamoDB table for state locking
terraform {
  backend "s3" {
    bucket         = "ganesh-terraform-state-prod"
    key            = "devops-platform/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
