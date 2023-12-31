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


module "rabbitmq" {
  source = "git::https://github.com/sairm21/tf-rabbitmq-module.git"

  for_each = var.rabbitmq
  component = each.value["component"]
  instance_type = each.value["instance_type"]

  sg_subnet_cidr = lookup(lookup(lookup(lookup(var.VPC, "main", null), "subnets", null), "app", null), "cidr_block", null)
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
  sg_subnet_cidr = lookup(lookup(lookup(lookup(var.VPC, "main", null), "subnets", null), "app", null), "cidr_block", null)
  vpc_id = lookup(lookup(module.roboshop_VPC, "main", null), "vpc_id", null)

  tags = var.tags
  env = var.env
  kms_key_id = var.kms_key_id
}

module "documentdb" {
  source = "git::https://github.com/sairm21/tf-documentdb-module.git"

  for_each = var.documentdb

  component = each.value["component"]
  engine = each.value["engine"]
  engine_version = each.value["engine_version"]
  db_instance_count = each.value["db_instance_count"]
  db_instance_class  = each.value["db_instance_class"]

  subnet_ids = lookup(lookup(lookup(lookup(module.roboshop_VPC, "main", null), "subnet_id", null), "db", null), "subnet_id", null)
  sg_subnet_cidr = lookup(lookup(lookup(lookup(var.VPC, "main", null), "subnets", null), "app", null), "cidr_block", null)
  vpc_id = lookup(lookup(module.roboshop_VPC, "main", null), "vpc_id", null)

  tags = var.tags
  env = var.env
  kms_key_id = var.kms_key_id
}

module "elasticache" {
  source = "git::https://github.com/sairm21/tf-elasticache-module.git"

  for_each = var.elasticache
  component = each.value["component"]
  engine = each.value["engine"]
  engine_version = each.value["engine_version"]
  num_node_groups = each.value["num_node_groups"]
  replicas_per_node_group = each.value["replicas_per_node_group"]
  node_type = each.value["node_type"]
  parameter_group_name = each.value["parameter_group_name"]

  subnet_ids = lookup(lookup(lookup(lookup(module.roboshop_VPC, "main", null), "subnet_id", null), "db", null), "subnet_id", null)
  sg_subnet_cidr = lookup(lookup(lookup(lookup(var.VPC, "main", null), "subnets", null), "app", null), "cidr_block", null)
  vpc_id = lookup(lookup(module.roboshop_VPC, "main", null), "vpc_id", null)

  tags = var.tags
  env = var.env
  kms_key_id = var.kms_key_id
}


module "alb" {
  source = "git::https://github.com/sairm21/tf-alb-module.git"

  for_each = var.alb

  name = each.value["name"]
  internal = each.value["internal"]
  load_balancer_type = each.value["load_balancer_type"]

  vpc_id = lookup(lookup(module.roboshop_VPC, "main", null), "vpc_id", null)
  sg_subnet_cidr = each.value["name"] == "Public" ? ["0.0.0.0/0"] : local.app_web_subnet_cidr
  subnet_ids = lookup(lookup(lookup(lookup(module.roboshop_VPC, "main", null), "subnet_id", null), each.value["subnets_ref"], null), "subnet_id", null)

  tags = var.tags
  env= var.env

}
module "apps" {

  depends_on = [module.roboshop_VPC, module.alb, module.documentdb, module.elasticache, module.rabbitmq, module.rds]
  source    = "git::https://github.com/sairm21/terraform-module-app.git"

  for_each = var.apps
  component = each.value["component"]
  app_port = each.value["app_port"]
  instance_type = each.value["instance_type"]
  min_size = each.value["min_size"]
  max_size = each.value["max_size"]
  desired_capacity = each.value["desired_capacity"]
  lb_rule_priority = each.value["lb_rule_priority"]
  param_access = try(each.value["param_access"], [])

  env       = var.env
  tags      = var.tags
  kms_key_id = var.kms_key_id
  bastion_host = var.bastion_host
  allow_prometheus = var.allow_prometheus

  sg_subnets_cidr = each.value["component"] == "frontend" ? local.public_web_subnet_cidr : lookup(lookup(lookup(lookup(var.VPC, "main", null), "subnets", null), each.value["subnets_ref"], null), "cidr_block", null)
  vpc_id    = lookup(lookup(module.roboshop_VPC, "main", null), "vpc_id", null)
  subnets = lookup(lookup(lookup(lookup(module.roboshop_VPC, "main", null), "subnet_id", null), each.value["subnets_ref"], null), "subnet_id", null)
  lb_dns_name = lookup(lookup(module.alb, each.value["lb_ref"], null), "lb_dns_name", null)
  listener_arn = lookup(lookup(module.alb, each.value["lb_ref"], null), "listener_arn", null)
}

