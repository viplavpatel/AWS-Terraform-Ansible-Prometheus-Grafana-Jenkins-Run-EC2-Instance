terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = "eu-west-2"
  shared_credentials_files = ["~/.aws/credentials"] // Path to AWS credentials file
  # Credentials will be read from environment variables:
  # AWS_ACCESS_KEY_ID
  # AWS_SECRET_ACCESS_KEY
  # AWS_SESSION_TOKEN (optional, for temporary credentials)
}