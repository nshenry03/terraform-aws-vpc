provider "aws" {
  region = "${var.region}"
}

data "aws_availability_zones" "available" {}

module "this" {
  source = "../.."

  tags = {
    Description = "Terraform module test - ${timestamp()}"
  }
}
