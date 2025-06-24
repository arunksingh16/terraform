# AWS VPC Network Terraform Module

This module creates a complete AWS VPC network infrastructure with multi-AZ subnets, NAT gateways, Internet gateways, route tables, and VPC Flow Logs.

## Features

- Creates VPCs with customizable CIDR blocks and DNS settings
- Creates subnets with explicit availability zone placement
- Supports both public and private subnets with appropriate route tables
- Creates Internet Gateways for public subnet internet access
- Creates NAT Gateways for private subnet internet access
- Configures VPC Flow Logs for network traffic monitoring
- Fully customizable via input variables

## Usage

```hcl
module "vpc" {
  source = "../../modules/network"
  
  vpc_parameters = {
    main_vpc = {
      cidr_block = "10.0.0.0/16"
      tags = {
        Environment = "production"
      }
    }
  }
  
  subnet_parameters = {
    public_subnet_az1 = {
      cidr_block              = "10.0.1.0/24"
      vpc_name                = "main_vpc"
      availability_zone       = "us-west-2a"
      map_public_ip_on_launch = true
      tags = {
        Type = "Public"
      }
    },
    private_subnet_az1 = {
      cidr_block         = "10.0.2.0/24"
      vpc_name           = "main_vpc"
      availability_zone  = "us-west-2a"
      tags = {
        Type = "Private"
      }
    }
  }
  
  # Additional parameters...
}
```

## Input Variables

| Name | Description | Type | Required |
|------|-------------|------|----------|
| vpc_parameters | Map of VPC configurations | map(object) | Yes |
| subnet_parameters | Map of subnet configurations | map(object) | Yes |
| igw_parameters | Map of Internet Gateway configurations | map(object) | No |
| nat_gateway_parameters | Map of NAT Gateway configurations | map(object) | No |
| rt_parameters | Map of Route Table configurations | map(object) | No |
| rt_association_parameters | Map of Route Table Association configurations | map(object) | No |
| flow_log_parameters | Map of VPC Flow Log configurations | map(object) | No |

## Outputs

| Name | Description |
|------|-------------|
| vpcs | Map of VPC IDs and CIDR blocks |
| subnets | Map of subnet IDs, CIDR blocks, and availability zones |
| nat_gateways | Map of NAT Gateway IDs and their public IPs |
| route_tables | Map of route table IDs |
| internet_gateways | Map of Internet Gateway IDs |

## Best Practices

1. Always distribute your subnets across multiple AZs for high availability
2. Use private subnets for backend services and databases
3. Use public subnets only for resources that need direct internet access
4. Consider using VPC endpoints for AWS services to avoid sending traffic over the public internet
5. Enable VPC Flow Logs for security and troubleshooting purposes

## Example

See the examples directory
