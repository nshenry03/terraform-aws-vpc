AWS VPC Terraform module
========================

Terraform module which creates VPC resources on AWS.

These types of resources are supported:

* [VPC](https://www.terraform.io/docs/providers/aws/r/vpc.html)

Usage
-----

```hcl
module "vpc" {
  ...
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| azs | A list of availability zones in the region | list | `[]` | no |
| cidr | The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden | string | `0.0.0.0/0` | no |
| create\_database\_nat\_gateway\_route | Controls if a nat gateway route should be created to give internet access to the database subnets | string | `false` | no |
| create\_vpc | Controls if VPC should be created (it affects almost all resources) | string | `true` | no |
| database\_route\_table\_tags | Additional tags for the database route tables | map | `{}` | no |
| database\_subnet\_group\_tags | Additional tags for the database subnet group | map | `{}` | no |
| database\_subnet\_suffix | Suffix to append to database subnets name | string | `db` | no |
| database\_subnet\_tags | Additional tags for the database subnets | map | `{}` | no |
| database\_subnets | A list of database subnets | list | `[]` | no |
| external\_nat\_ip\_ids | List of EIP IDs to be assigned to the NAT Gateways (used in combination with reuse_nat_ips) | list | `[]` | no |
| igw\_tags | Additional tags for the internet gateway | map | `{}` | no |
| intra\_route\_table\_tags | Additional tags for the intra route tables | map | `{}` | no |
| intra\_subnet\_suffix | Suffix to append to intra subnets name | string | `intra` | no |
| intra\_subnet\_tags | Additional tags for the intra subnets | map | `{}` | no |
| intra\_subnets | A list of intra subnets | list | `[]` | no |
| name | Name to be used on all the resources as identifier | string | `` | no |
| nat\_eip\_tags | Additional tags for the NAT EIP | map | `{}` | no |
| nat\_gateway\_tags | Additional tags for the NAT gateways | map | `{}` | no |
| private\_route\_table\_tags | Additional tags for the private route tables | map | `{}` | no |
| private\_subnet\_suffix | Suffix to append to private subnets name | string | `private` | no |
| private\_subnet\_tags | Additional tags for the private subnets | map | `{}` | no |
| private\_subnets | A list of private subnets inside the VPC | list | `[]` | no |
| public\_route\_table\_tags | Additional tags for the public route tables | map | `{}` | no |
| public\_subnet\_suffix | Suffix to append to public subnets name | string | `public` | no |
| public\_subnet\_tags | Additional tags for the public subnets | map | `{}` | no |
| public\_subnets | A list of public subnets inside the VPC | list | `[]` | no |
| reuse\_nat\_ips | Should be true if you don't want EIPs to be created for your NAT Gateways and will instead pass them in via the 'external_nat_ip_ids' variable | string | `false` | no |
| tags | A map of tags to add to all resources | map | `{}` | no |
| vpc\_tags | Additional tags for the VPC | map | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| azs | A list of availability zones specified as argument to this module |
| database\_route\_table\_ids | List of IDs of database route tables |
| database\_subnet\_group | ID of database subnet group |
| database\_subnets | List of IDs of database subnets |
| database\_subnets\_cidr\_blocks | List of cidr_blocks of database subnets |
| default\_network\_acl\_id | The ID of the default network ACL |
| default\_route\_table\_id | The ID of the default route table |
| default\_security\_group\_id | The ID of the security group created by default on VPC creation |
| igw\_id | The ID of the Internet Gateway |
| intra\_route\_table\_ids | List of IDs of intra route tables |
| intra\_subnets | List of IDs of intra subnets |
| intra\_subnets\_cidr\_blocks | List of cidr_blocks of intra subnets |
| nat\_ids | List of allocation ID of Elastic IPs created for AWS NAT Gateway |
| nat\_public\_ips | List of public Elastic IPs created for AWS NAT Gateway |
| natgw\_ids | List of NAT Gateway IDs |
| private\_route\_table\_ids | List of IDs of private route tables |
| private\_subnets | List of IDs of private subnets |
| private\_subnets\_cidr\_blocks | List of cidr_blocks of private subnets |
| public\_route\_table\_ids | List of IDs of public route tables |
| public\_subnets | List of IDs of public subnets |
| public\_subnets\_cidr\_blocks | List of cidr_blocks of public subnets |
| vpc\_cidr\_block | The CIDR block of the VPC |
| vpc\_id | The ID of the VPC |
| vpc\_main\_route\_table\_id | The ID of the main route table associated with this VPC |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

Tests
-----

This module has been packaged with [awspec](https://github.com/k1LoW/awspec)
tests through test kitchen. To run them:

1. Install [rvm][1] and the ruby version specified in the `Gemfile`
1. Install bundler and the gems from our Gemfile:

    ```bash
    gem install bundler && bundle install
    ```

1. Test using `bundle exec kitchen test` from the root of the repo.

License
-------

All Rights Reserved. See LICENSE for full details.


[1]: https://rvm.io/rvm/install
