# count example

##########################
#    BACKEND
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

##########################
#    PROVIDER
##########################

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
  default = "xx"
}

variable "aws_secret_access_key" {
  default = "xx"
}

####################
## You can provide your credentials via the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY, 
## environment variables, representing your AWS Access Key and AWS Secret Key, respectively.
## export AWS_ACCESS_KEY_ID="anaccesskey"
## export AWS_SECRET_ACCESS_KEY="asecretkey"
## export AWS_DEFAULT_REGION="us-west-2"
####################

resource "aws_iam_user" "iam_accnt" {
  count = 3
  name  = "accnt-${count.index}"
}


