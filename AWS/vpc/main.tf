resource "aws_vpc" "this" {
  for_each             = var.vpc_parameters
  cidr_block           = each.value.cidr_block
  enable_dns_support   = each.value.enable_dns_support
  enable_dns_hostnames = each.value.enable_dns_hostnames
  tags = merge(each.value.tags, {
    Name : each.key
  })
}

resource "aws_subnet" "this" {
  for_each                = var.subnet_parameters
  vpc_id                  = aws_vpc.this[each.value.vpc_name].id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  tags = merge(each.value.tags, {
    Name : each.key
  })
}

resource "aws_internet_gateway" "this" {
  for_each = var.igw_parameters
  vpc_id   = aws_vpc.this[each.value.vpc_name].id
  tags = merge(each.value.tags, {
    Name : each.key
  })
}

resource "aws_eip" "nat" {
  for_each = var.nat_gateway_parameters
  domain   = "vpc"
  tags = merge(each.value.tags, {
    Name : each.key
  })
}

resource "aws_nat_gateway" "this" {
  for_each      = var.nat_gateway_parameters
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.this[each.value.subnet_name].id
  tags = merge(each.value.tags, {
    Name : each.key
  })

  depends_on = [aws_internet_gateway.this]
}

resource "aws_route_table" "this" {
  for_each = var.rt_parameters
  vpc_id   = aws_vpc.this[each.value.vpc_name].id
  tags = merge(each.value.tags, {
    Name : each.key
  })

  dynamic "route" {
    for_each = each.value.routes
    content {
      cidr_block = route.value.cidr_block
      gateway_id = route.value.use_igw ? aws_internet_gateway.this[route.value.gateway_id].id : (
        can(aws_nat_gateway.this[route.value.gateway_id]) ? aws_nat_gateway.this[route.value.gateway_id].id : route.value.gateway_id
      )
    }
  }
}

resource "aws_route_table_association" "this" {
  for_each       = var.rt_association_parameters
  subnet_id      = aws_subnet.this[each.value.subnet_name].id
  route_table_id = aws_route_table.this[each.value.rt_name].id
}

# VPC Flow Logs
resource "aws_flow_log" "this" {
  for_each             = var.flow_log_parameters
  log_destination      = each.value.log_destination
  log_destination_type = each.value.log_destination_type
  traffic_type         = each.value.traffic_type
  vpc_id               = aws_vpc.this[each.value.vpc_name].id
  tags = merge(each.value.tags, {
    Name : each.key
  })
}
