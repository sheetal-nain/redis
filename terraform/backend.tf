terraform {
  backend "s3" {
    bucket         = "terraform-bucket-a"   # Replace with your S3 bucket name
    key            = "terraform/terraform.tfstate"      # Path within the bucket
    region         = "ap-south-1"               # Replace with your AWS region
    encrypt        = true
    dynamodb_table = "terraform-state-lock"         # Replace with your DynamoDB table name
  }
}
