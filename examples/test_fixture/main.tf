provider "aws" {
  region              = "${var.region}"
  allowed_account_ids = ["${var.aws_allowed_account_ids}"]
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source           = "../.."
  name             = "${var.user}-vpc-mod"
  cidr             = "10.0.0.0/16"
  azs              = ["${data.aws_availability_zones.available.names[0]}", "${data.aws_availability_zones.available.names[1]}"]
  private_subnets  = ["10.0.10.0/24", "10.0.11.0/24"]
  public_subnets   = ["10.0.20.0/24", "10.0.21.0/24"]
  database_subnets = ["10.0.30.0/24", "10.0.31.0/24"]
  intra_subnets    = ["10.0.40.0/24", "10.0.41.0/24"]

  tags = {
    Owner       = "${var.user}"
    Environment = "dev"
  }
}
