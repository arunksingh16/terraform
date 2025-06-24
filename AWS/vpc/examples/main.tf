terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Get available availability zones
data "aws_availability_zones" "available" {
  state = "available"
}


# Create S3 bucket with account ID and region in name
resource "aws_s3_bucket" "vpc_flow_logs" {
  bucket = "vpclogs-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
  tags = {
    Purpose     = "vpclogs"
  }
}



# Create a multi-AZ VPC setup with proper public and private subnets
module "vpc" {
  source = "../../modules/network"
  vpc_parameters = {
    vpc1 = {
      cidr_block = "10.0.0.0/16"
      tags = {
        Environment = "poc"
      }
    }
  }
  
  # Public subnets in multiple AZs
  subnet_parameters = {
    public-subnet-az1 = {
      cidr_block              = "10.0.1.0/24"
      vpc_name                = "vpc1"
      availability_zone       = data.aws_availability_zones.available.names[0]
      map_public_ip_on_launch = true
      tags = {
        Name = "public-subnet-az1"
        Type = "Public"
        "kubernetes.io/role/elb" = "1"  # Tag for EKS if applicable
      }
    },
    public-subnet-az2 = {
      cidr_block              = "10.0.2.0/24"
      vpc_name                = "vpc1"
      availability_zone       = data.aws_availability_zones.available.names[1]
      map_public_ip_on_launch = true
      tags = {
        Name = "public-subnet-az2"
        Type = "Public"
        "kubernetes.io/role/elb" = "1"  # Tag for EKS if applicable
      }
    },
    # Private subnets in multiple AZs
    private-subnet-az1 = {
      cidr_block         = "10.0.3.0/24"
      vpc_name           = "vpc1"
      availability_zone  = data.aws_availability_zones.available.names[0]
      tags = {
        Name = "private-subnet-az1"
        Type = "Private"
        "kubernetes.io/role/internal-elb" = "1"  # Tag for EKS if applicable
      }
    },
    private-subnet-az2 = {
      cidr_block         = "10.0.4.0/24"
      vpc_name           = "vpc1"
      availability_zone  = data.aws_availability_zones.available.names[1]
      tags = {
        Name = "private-subnet-az2"
        Type = "Private"
        "kubernetes.io/role/internal-elb" = "1"  # Tag for EKS if applicable
      }
    }
  }
  
  # Internet Gateway for public access
  igw_parameters = {
    igw1 = {
      vpc_name = "vpc1"
      tags = {
        Name = "igw-vpc1"
      }
    }
  }
  
  # NAT Gateway for private subnet internet access
  nat_gateway_parameters = {
    natgw-az1 = {
      subnet_name = "public-subnet-az1"
      tags = {
        Name = "natgw-az1"
      }
    }
  }
  
  # Route tables for public and private subnets
  rt_parameters = {
    public-rt = {
      vpc_name = "vpc1"
      tags = {
        Name = "public-rt"
        Type = "Public"
      }
      routes = [{
        cidr_block = "0.0.0.0/0"
        gateway_id = "igw1"
      }]
    },
    private-rt = {
      vpc_name = "vpc1"
      tags = {
        Name = "private-rt"
        Type = "Private"
      }
      routes = [{
        cidr_block = "0.0.0.0/0"
        # NAT Gateway reference - using AWS resource ID format for the NAT Gateway
        gateway_id = "natgw-az1" 
        use_igw    = false
      }]
    }
  }
  
  # Route table associations
  rt_association_parameters = {
    public-rt-assoc-az1 = {
      subnet_name = "public-subnet-az1"
      rt_name     = "public-rt"
    },
    public-rt-assoc-az2 = {
      subnet_name = "public-subnet-az2"
      rt_name     = "public-rt"
    },
    private-rt-assoc-az1 = {
      subnet_name = "private-subnet-az1"
      rt_name     = "private-rt"
    },
    private-rt-assoc-az2 = {
      subnet_name = "private-subnet-az2"
      rt_name     = "private-rt"
    }
  }
  
  
  # Optional: VPC Flow Logs for network monitoring
  flow_log_parameters = {
    vpc1-flow-log = {
      vpc_name        = "vpc1"
      traffic_type    = "ALL"
      log_destination = aws_s3_bucket.vpc_flow_logs.arn
      tags = {
        Name = "vpc1-flow-log"
      }
    }
  }
}

# Outputs
