provider "aws" {
  region              = "${var.region}"
  allowed_account_ids = ["${var.aws_allowed_account_ids}"]
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source          = "../.."
  name            = "test-example"
  cidr            = "10.0.0.0/16"
  azs             = ["${data.aws_availability_zones.available.names[0]}", "${data.aws_availability_zones.available.names[1]}"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  tags = {
    Owner       = "${var.user}"
    Environment = "dev"
  }
}
