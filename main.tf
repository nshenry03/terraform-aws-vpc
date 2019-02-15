terraform {
  required_version = ">= 0.10.3" # introduction of `Local Values` configuration language feature
}

locals {
  vpc_id = "${element(concat(aws_vpc_ipv4_cidr_block_association.this.*.vpc_id, aws_vpc.this.*.id, list("")), 0)}"

  route_create_timeout = "5m"

  # Workaround for interpolation not being able to "short-circuit" the evaluation of the conditional branch that doesn't end up being used
  # Source: https://github.com/hashicorp/terraform/issues/11566#issuecomment-289417805
  #
  # The logical expression would be
  #
  #    nat_gateway_ips = var.reuse_nat_ips ? var.external_nat_ip_ids : aws_eip.nat.*.id
  #
  # but then when count of aws_eip.nat.*.id is zero, this would throw a resource not found error on aws_eip.nat.*.id.
  nat_gateway_ips = "${split(",", (var.reuse_nat_ips ? join(",", var.external_nat_ip_ids) : join(",", aws_eip.nat.*.id)))}"
}

######
# VPC
######
resource "aws_vpc" "this" {
  count = "${var.create_vpc ? 1 : 0}"

  cidr_block = "${var.cidr}"

  tags = "${merge(map("Name", format("%s", var.name)), var.tags, var.vpc_tags)}"
}

###################
# Internet Gateway
###################
resource "aws_internet_gateway" "this" {
  count = "${var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0}"

  vpc_id = "${local.vpc_id}"

  tags = "${merge(map("Name", format("%s", var.name)), var.tags, var.igw_tags)}"
}

##############
# NAT Gateway
##############
resource "aws_eip" "nat" {
  count = "${var.create_vpc && !var.reuse_nat_ips ? length(var.azs) : 0}"

  vpc = true

  tags = "${merge(map("Name", format("%s-%s", var.name, element(var.azs, count.index))), var.tags, var.nat_eip_tags)}"
}

resource "aws_nat_gateway" "this" {
  count = "${var.create_vpc ? length(var.azs) : 0}"

  allocation_id = "${element(local.nat_gateway_ips, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"

  tags = "${merge(map("Name", format("%s-%s", var.name, element(var.azs, count.index))), var.tags, var.nat_gateway_tags)}"

  depends_on = ["aws_internet_gateway.this"]
}

##########
# Subnets
##########
# --------------
# public subnet
# --------------
resource "aws_subnet" "public" {
  count = "${var.create_vpc && length(var.public_subnets) > 0 ? length(var.public_subnets) : 0}"

  vpc_id            = "${local.vpc_id}"
  cidr_block        = "${element(concat(var.public_subnets, list("")), count.index)}"
  availability_zone = "${element(var.azs, count.index)}"

  tags = "${merge(map("Name", format("%s-${var.public_subnet_suffix}-%s", var.name, element(var.azs, count.index))), var.tags, var.public_subnet_tags)}"
}

resource "aws_route_table" "public" {
  count = "${var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0}"

  vpc_id = "${local.vpc_id}"

  tags = "${merge(map("Name", format("%s-${var.public_subnet_suffix}", var.name)), var.tags, var.public_route_table_tags)}"
}

resource "aws_route" "public_internet_gateway" {
  count = "${var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0}"

  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.this.id}"

  timeouts {
    create = "${local.route_create_timeout}"
  }
}

# ---------------
# private subnet
# ---------------
resource "aws_subnet" "private" {
  count = "${var.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0}"

  vpc_id            = "${local.vpc_id}"
  cidr_block        = "${element(var.private_subnets, count.index)}"
  availability_zone = "${element(var.azs, count.index)}"

  tags = "${merge(map("Name", format("%s-${var.private_subnet_suffix}-%s", var.name, element(var.azs, count.index))), var.tags, var.private_subnet_tags)}"
}

resource "aws_route_table" "private" {
  count = "${var.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0}"

  vpc_id = "${local.vpc_id}"

  tags = "${merge(map("Name", format("%s-${var.private_subnet_suffix}-%s", var.name, element(var.azs, count.index))), var.tags, var.private_route_table_tags)}"
}

resource "aws_route" "private_nat_gateway" {
  count = "${var.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0}"

  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.this.*.id, count.index)}"

  timeouts {
    create = "${local.route_create_timeout}"
  }
}

resource "aws_route_table_association" "private" {
  count = "${var.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0}"

  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

# ----------------
# database subnet
# ----------------
resource "aws_subnet" "database" {
  count = "${var.create_vpc && length(var.database_subnets) > 0 ? length(var.database_subnets) : 0}"

  vpc_id            = "${local.vpc_id}"
  cidr_block        = "${element(var.database_subnets, count.index)}"
  availability_zone = "${element(var.azs, count.index)}"

  tags = "${merge(map("Name", format("%s-${var.database_subnet_suffix}-%s", var.name, element(var.azs, count.index))), var.tags, var.database_subnet_tags)}"
}

resource "aws_db_subnet_group" "database" {
  count = "${var.create_vpc && length(var.database_subnets) > 0 ? 1 : 0}"

  name        = "${lower(var.name)}"
  description = "Database subnet group for ${var.name}"
  subnet_ids  = ["${aws_subnet.database.*.id}"]

  tags = "${merge(map("Name", format("%s", var.name)), var.tags, var.database_subnet_group_tags)}"
}

resource "aws_route_table" "database" {
  count = "${var.create_vpc && length(var.database_subnets) > 0 ? length(var.database_subnets) : 0}"

  vpc_id = "${local.vpc_id}"

  tags = "${merge(var.tags, var.database_route_table_tags, map("Name", "${var.name}-${var.database_subnet_suffix}"))}"
}

resource "aws_route" "database_nat_gateway" {
  count                  = "${var.create_vpc && var.create_database_nat_gateway_route && length(var.database_subnets) > 0 ? length(var.database_subnets) : 0}"
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.this.*.id, count.index)}"

  timeouts {
    create = "${local.route_create_timeout}"
  }
}

resource "aws_route_table_association" "database" {
  count = "${var.create_vpc && length(var.database_subnets) > 0 ? length(var.database_subnets) : 0}"

  subnet_id      = "${element(aws_subnet.database.*.id, count.index)}"
  route_table_id = "${element(coalescelist(aws_route_table.database.*.id, aws_route_table.private.*.id), count.index)}"
}

# -------------
# intra subnet
# -------------
resource "aws_subnet" "intra" {
  count = "${var.create_vpc && length(var.intra_subnets) > 0 ? length(var.intra_subnets) : 0}"

  vpc_id            = "${local.vpc_id}"
  cidr_block        = "${element(var.intra_subnets, count.index)}"
  availability_zone = "${element(var.azs, count.index)}"

  tags = "${merge(map("Name", format("%s-intra-%s", var.name, element(var.azs, count.index))), var.tags, var.intra_subnet_tags)}"
}

resource "aws_route_table" "intra" {
  count = "${var.create_vpc && length(var.intra_subnets) > 0 ? 1 : 0}"

  vpc_id = "${local.vpc_id}"

  tags = "${merge(map("Name", "${var.name}-intra"), var.tags, var.intra_route_table_tags)}"
}

resource "aws_route_table_association" "intra" {
  count = "${var.create_vpc && length(var.intra_subnets) > 0 ? length(var.intra_subnets) : 0}"

  subnet_id      = "${element(aws_subnet.intra.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.intra.*.id, 0)}"
}
