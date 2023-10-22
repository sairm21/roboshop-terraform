locals {
  app_web_subnet_cidr = concat(lookup(lookup(lookup(lookup(var.VPC, "main", null), "subnets", null), "app", null), "cidr_block", null), lookup(lookup(lookup(lookup(var.VPC, "main", null), "subnets", null), "web", null), "cidr_block", null))
  public_web_subnet_cidr = concat(lookup(lookup(lookup(lookup(var.VPC, "main", null), "subnets", null), "Public", null), "cidr_block", null), lookup(lookup(lookup(lookup(var.VPC, "main", null), "subnets", null), "web", null), "cidr_block", null))
}