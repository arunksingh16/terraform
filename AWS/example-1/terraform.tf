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

# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


####################
## You can provide your credentials via the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY, 
## environment variables, representing your AWS Access Key and AWS Secret Key, respectively.
## export AWS_ACCESS_KEY_ID="anaccesskey"
## export AWS_SECRET_ACCESS_KEY="asecretkey"
## export AWS_DEFAULT_REGION="us-west-2"
####################
