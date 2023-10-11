/*
module "roboshop_instances" {
  for_each = var.components
  source = "git::https://github.com/sairm21/terraform-module-app.git"
  component= each.key
  env =var.env
  tags = merge(each.value["tags"], var.tags)
}*/

module "roboshop_VPC" {
  source = "git::https://github.com/sairm21/tf-vpc-module.git"
  for_each = var.VPC
  cidr_block = each.value["cidr_block"]
  subnets = each.value["subnets"]
  env =var.env
  tags = var.tags
  default_VPC_id = var.default_VPC_id # this argument will be passed to module
  default_Route_table_ID = var.default_Route_table_ID
}


module "appserver" {
  source    = "git::https://github.com/sairm21/terraform-module-app.git"
  component = "test"
  env       = var.env
  tags      = var.tags
  vpc_id    = lookup(lookup(module.roboshop_VPC, "main", null), "vpc_id", null)
  subnet_id = lookup(lookup(lookup(lookup(module.roboshop_VPC, "main", null), "subnet_id", null), "app", null), "subnet_id", null)[0]
}

module "rabbitmq" {
  source = "git::https://github.com/sairm21/tf-rabbitmq-module.git"

  for_each = var.rabbitmq
  component = each.value["component"]
  instance_type = each.value["instance_type"]

  sg_subnet_cidr = lookup(lookup(lookup(lookup(var.VPC, "main", null), "subnets", null), "db", null), "cidr_block", null)
  vpc_id = lookup(lookup(module.roboshop_VPC, "main", null), "vpc_id", null)
  subnet_id = lookup(lookup(lookup(lookup(module.roboshop_VPC, "main", null), "subnet_id", null), "db", null), "subnet_id", null)[0]

  env = var.env
  tags = var.tags
  kms_key_id = var.kms_key_id

  bastion_host = var.bastion_host
  zone_id = var.zone_id
}


module "rds" {
  source = "git::https://github.com/sairm21/tf-rds-module.git"

  for_each = var.rds
  component = each.value["component"]
  engine = each.value["engine"]
  engine_version = each.value["engine_version"]
  database_name = each.value["database_name"]
  instance_count = each.value["instance_count"]
  instance_class = each.value["instance_class"]
  subnet_ids = lookup(lookup(lookup(lookup(module.roboshop_VPC, "main", null), "subnet_id", null), "db", null), "subnet_id", null)
  sg_subnet_cidr = lookup(lookup(lookup(lookup(var.VPC, "main", null), "subnets", null), "db", null), "cidr_block", null)
  vpc_id = lookup(lookup(module.roboshop_VPC, "main", null), "vpc_id", null)

  tags = var.tags
  env = var.env
  kms_key_id = var.kms_key_id

}
