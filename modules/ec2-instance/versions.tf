terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.62"
    }
  }
  required_version = ">= 1.4.0"
}