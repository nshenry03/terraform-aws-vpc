######
# Module
######
variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

######
# VPC
######
variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  default     = true
}

variable "cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  default     = "0.0.0.0/0"
}

variable "azs" {
  description = "A list of availability zones in the region"
  default     = []
}

variable "vpc_tags" {
  description = "Additional tags for the VPC"
  default     = {}
}

###################
# Internet Gateway
###################
variable "igw_tags" {
  description = "Additional tags for the internet gateway"
  default     = {}
}

##############
# NAT Gateway
##############
variable "reuse_nat_ips" {
  description = "Should be true if you don't want EIPs to be created for your NAT Gateways and will instead pass them in via the 'external_nat_ip_ids' variable"
  default     = false
}

variable "external_nat_ip_ids" {
  description = "List of EIP IDs to be assigned to the NAT Gateways (used in combination with reuse_nat_ips)"
  type        = "list"
  default     = []
}

variable "nat_eip_tags" {
  description = "Additional tags for the NAT EIP"
  default     = {}
}

variable "nat_gateway_tags" {
  description = "Additional tags for the NAT gateways"
  default     = {}
}

##########
# Subnets
##########
# --------------
# public subnet
# --------------
variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  default     = []
}

variable "public_subnet_suffix" {
  description = "Suffix to append to public subnets name"
  default     = "public"
}

variable "public_route_table_tags" {
  description = "Additional tags for the public route tables"
  default     = {}
}

variable "public_subnet_tags" {
  description = "Additional tags for the public subnets"
  default     = {}
}

# ---------------
# private subnet
# ---------------
variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  default     = []
}

variable "private_subnet_suffix" {
  description = "Suffix to append to private subnets name"
  default     = "private"
}

variable "private_route_table_tags" {
  description = "Additional tags for the private route tables"
  default     = {}
}

variable "private_subnet_tags" {
  description = "Additional tags for the private subnets"
  default     = {}
}

# ----------------
# database subnet
# ----------------
variable "database_subnets" {
  type        = "list"
  description = "A list of database subnets"
  default     = []
}

variable "create_database_nat_gateway_route" {
  description = "Controls if a nat gateway route should be created to give internet access to the database subnets"
  default     = false
}

variable "database_subnet_suffix" {
  description = "Suffix to append to database subnets name"
  default     = "db"
}

variable "database_subnet_group_tags" {
  description = "Additional tags for the database subnet group"
  default     = {}
}

variable "database_route_table_tags" {
  description = "Additional tags for the database route tables"
  default     = {}
}

variable "database_subnet_tags" {
  description = "Additional tags for the database subnets"
  default     = {}
}

# ----------------
# intra subnet
# ----------------
variable "intra_subnets" {
  type        = "list"
  description = "A list of intra subnets"
  default     = []
}

variable "intra_subnet_suffix" {
  description = "Suffix to append to intra subnets name"
  default     = "intra"
}

variable "intra_route_table_tags" {
  description = "Additional tags for the intra route tables"
  default     = {}
}

variable "intra_subnet_tags" {
  description = "Additional tags for the intra subnets"
  default     = {}
}
