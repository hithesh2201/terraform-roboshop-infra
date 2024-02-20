terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0"
    }
  }

  backend "s3" {
    bucket         = "tfstate-hiteshshop" # for collabartion and security reasons we are going to use s3 and dynamodb
    key            = "vpc-infra"
    region         = "us-east-1"
    dynamodb_table = "test"
  }


}

provider "aws" {
  region = "us-east-1"
}

