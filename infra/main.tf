terraform {
  required_providers {
    ansible = {
        source = "nbering/ansible"
        version = "1.0.4"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "jackbazbackend"
    key    = "tests/k8s-testing/cluster.tfstate"
    region = "eu-west-1"
  }

}

provider "aws" {
  region = "eu-west-1"
  assume_role_with_web_identity {
    role_arn                = "arn:aws:iam::520686339686:role/github-oidc"
    session_name            = "github-test"
    web_identity_token_file = "/tmp/web_identity_token_file"
  }
}