locals {
  len_public_subnets  = max(length(var.public_subnets))
  len_private_subnets = max(length(var.private_subnets))

  max_subnet_length = max(
    local.len_public_subnets,
    local.len_private_subnets,
  )
}

################################################################################
# VPC
################################################################################

resource "aws_vpc" "this" {
  cidr_block = var.cidr

  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    var.tags,
    var.vpc_tags
  )
}

################################################################################
# Public Subnets
################################################################################

resource "aws_subnet" "public" {
  count = local.len_public_subnets >= length(var.azs) ? local.len_public_subnets : 0

  availability_zone = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  cidr_block        = element(concat(var.public_subnets, [""]), count.index)
  vpc_id            = aws_vpc.this.id

  tags = merge(
    var.tags,
    var.public_subnet_tags
  )
}

resource "aws_route_table" "public" {
  count = local.len_public_subnets > 0 ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    var.public_route_table_tags,
  )
}

resource "aws_route_table_association" "public" {
  count = local.len_public_subnets

  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public[0].id
}

resource "aws_route" "public_internet_gateway" {
  count = local.len_public_subnets > 0 && var.create_igw ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}

################################################################################
# Private Subnets
################################################################################

resource "aws_subnet" "private" {
  count = local.len_private_subnets

  availability_zone = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  cidr_block        = element(concat(var.private_subnets, [""]), count.index)
  vpc_id            = aws_vpc.this.id

  tags = merge(
    var.tags,
    var.private_subnet_tags
  )
}

# There are as many routing tables as the number of NAT gateways
resource "aws_route_table" "private" {
  count = local.len_private_subnets > 0 && local.max_subnet_length > 0 ? local.nat_gateway_count : 0

  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    var.private_route_table_tags,
  )
}

resource "aws_route_table_association" "private" {
  count = local.len_private_subnets

  subnet_id = element(aws_subnet.private[*].id, count.index)
  route_table_id = element(
    aws_route_table.private[*].id,
    var.single_nat_gateway ? 0 : count.index,
  )
}

################################################################################
# Internet Gateway
################################################################################

resource "aws_internet_gateway" "this" {
  count = var.create_igw ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    var.igw_tags,
  )
}

resource "aws_egress_only_internet_gateway" "this" {
  count = var.create_egress_only_igw && local.max_subnet_length > 0 ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    var.igw_tags,
  )
}

################################################################################
# NAT Gateway
################################################################################

locals {
  nat_gateway_count = var.single_nat_gateway ? 1 : var.one_nat_gateway_per_az ? length(var.azs) : local.max_subnet_length
  nat_gateway_ips   = try(aws_eip.nat[*].id, [])
}

resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? local.nat_gateway_count : 0

  vpc = true

  tags = merge(
    var.tags
  )
}

resource "aws_nat_gateway" "this" {
  count = var.enable_nat_gateway ? local.nat_gateway_count : 0

  allocation_id = element(
    local.nat_gateway_ips,
    var.single_nat_gateway ? 0 : count.index,
  )
  subnet_id = element(
    aws_subnet.public[*].id,
    var.single_nat_gateway ? 0 : count.index,
  )

  tags = merge(
    var.tags,
    var.nat_gateway_tags
  )

  depends_on = [aws_internet_gateway.this]
}

resource "aws_route" "private_nat_gateway" {
  count = var.enable_nat_gateway ? local.nat_gateway_count : 0

  route_table_id         = element(aws_route_table.private[*].id, count.index)
  destination_cidr_block = var.nat_gateway_destination_cidr_block
  nat_gateway_id         = element(aws_nat_gateway.this[*].id, count.index)

  timeouts {
    create = "5m"
  }
}