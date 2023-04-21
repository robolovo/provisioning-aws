terraform {
  required_version = ">= 1.4.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.62"
    }
  }

  backend "s3" {
    bucket  = "robolovo-test-terraform"
    region  = "us-west-2"
    key     = "regional/vpc/terraform.tfstate"
    encrypt = true
  }
}
