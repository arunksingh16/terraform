##########################
#    PROVIDER
##########################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}


provider "aws" {
  region = var.aws_region
  access_key= var.aws_access_key_id
  secret_key= var.aws_secret_access_key
}

##########################
#    VARIABLE
##########################

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

variable "aws_access_key_id" {
  default = "XXXXXX"
}

variable "aws_secret_access_key" {
  default = "XXXXXX"
}

##########################
#    RESOURCE
##########################

resource "aws_iam_user" "iam_accnt" {
  count = 3
  name  = "accnt-${count.index}"
}

