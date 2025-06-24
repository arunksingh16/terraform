output "vpcs" {
  description = "VPC Outputs"
  value       = { for vpc in aws_vpc.this : vpc.tags.Name => { "cidr_block" : vpc.cidr_block, "id" : vpc.id } }
}

output "subnets" {
  description = "Subnet Outputs"
  value       = { for subnet in aws_subnet.this : subnet.tags.Name => { 
    "id" : subnet.id, 
    "cidr_block" : subnet.cidr_block, 
    "availability_zone" : subnet.availability_zone 
  } }
}

output "nat_gateways" {
  description = "NAT Gateway Outputs"
  value       = { for nat in aws_nat_gateway.this : nat.tags.Name => { 
    "id" : nat.id, 
    "public_ip" : nat.public_ip
  } }
}

output "route_tables" {
  description = "Route Table Outputs"
  value       = { for rt in aws_route_table.this : rt.tags.Name => rt.id }
}

output "internet_gateways" {
  description = "Internet Gateway Outputs"
  value       = { for igw in aws_internet_gateway.this : igw.tags.Name => igw.id }
}
