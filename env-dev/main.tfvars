env = "dev"

components= {
  Frontend ={
    tags = { Monitor = "True", Env = "Dev"}
  }
  MongoDB ={
    tags = {Env = "Dev"}
  }
  Catalogue ={
    tags = { Monitor = "True", Env = "Dev"}
  }
  Redis ={
    tags = {Env = "Dev"}
  }
  User ={
    tags = { Monitor = "True", Env = "Dev"}
  }
  Cart ={
    tags = { Monitor = "True", Env = "Dev"}
  }
  MySQL ={
    tags = {Env = "Dev"}
  }
  Shipping ={
    tags = { Monitor = "True", Env = "Dev"}
  }
  RabbitMQ ={
    tags = {Env = "Dev"}
  }
  Payment ={
    tags = { Monitor = "True", Env = "Dev"}
  }
  Dispatch ={
    tags = { Monitor = "True", Env = "Dev"}
  }
}

tags={
  Company_name="SRK India Pvt Ltd."
  Business="ecommerce"
  Business_unit="Retail"
  center_ID= "45872"
  Project_name= "Roboshop"
}

VPC = {
  main = {
    cidr_block       = "10.10.0.0/16"

    subnets = {
      web = {
        cidr_block = ["10.10.0.0/24", "10.10.1.0/24"]
      }
      app = {
        cidr_block = ["10.10.2.0/24", "10.10.3.0/24"]
      }
      db = {
        cidr_block = ["10.10.4.0/24", "10.10.5.0/24"]
      }
      Public = {
        cidr_block = ["10.10.6.0/24", "10.10.7.0/24"]
      }
    }
  }
}

default_VPC_id = "vpc-e6e0959b"
default_Route_table_ID = "rtb-8d8a79fc"
bastion_host = ["172.31.7.59/32"]
zone_id = "Z07064001LQWEDMH2WVFL"

rabbitmq = {
  main = {
    component = "RabbitMQ"
    instance_type = "t3.small"
  }
}

rds = {
  main = {
    component      = "mysql"
    engine         = "aurora-mysql"
    engine_version = "5.7.mysql_aurora.2.11.3"
    database_name  = "mydb"
    instance_count = 1
    instance_class = "db.t3.small"
  }
}

documentdb = {
  main = {
    component      = "mongodb"
    engine         = "docdb"
    engine_version = "4.0.0"
    db_instance_count = 1
    db_instance_class = "db.t3.medium"
  }
}

elasticache ={
  main = {
    component               = "elasticache"
    engine                  = "redis"
    engine_version          = "6.x"
    num_node_groups         = 1
    replicas_per_node_group = 1
    node_type               = "cache.t3.micro"
    parameter_group_name    = "default.redis6.x.cluster.on"
  }
}

alb = {
  public = {
    name = "Public"
    internal = false
    load_balancer_type = "application"
    subnets_ref = "Public"
  }
  private = {
    name = "Private"
    internal = true
    load_balancer_type = "application"
    subnets_ref = "app"
  }
}

apps = {
  catalogue = {
    component = "catalogue"
    app_port = 8080
    instance_type = "t3.small"
    min_size = 1
    max_size = 2
    desired_capacity = 1
    subnets_ref = "app"
    lb_ref = "private"
    lb_rule_priority = 100
    param_access = ["arn:aws:ssm:us-east-1:804838709963:parameter/roboshop.dev.docdb.*"]
  }
  user = {
    component = "user"
    app_port = 8080
    instance_type = "t3.small"
    min_size = 1
    max_size = 2
    desired_capacity = 1
    subnets_ref = "app"
    lb_ref = "private"
    lb_rule_priority = 101
    param_access = ["arn:aws:ssm:us-east-1:804838709963:parameter/roboshop.dev.docdb.*"]
  }
  cart = {
    component = "cart"
    app_port = 8080
    instance_type = "t3.small"
    min_size = 1
    max_size = 2
    desired_capacity = 1
    subnets_ref = "app"
    lb_ref = "private"
    lb_rule_priority = 102
  }
  shipping = {
    component = "shipping"
    app_port = 8080
    instance_type = "t3.small"
    min_size = 1
    max_size = 2
    desired_capacity = 1
    subnets_ref = "app"
    lb_ref = "private"
    lb_rule_priority = 103
  }
  payment = {
    component = "payment"
    app_port = 8080
    instance_type = "t3.small"
    min_size = 1
    max_size = 2
    desired_capacity = 1
    subnets_ref = "app"
    lb_ref = "private"
    lb_rule_priority = 104
  }
  frontend = {
    component = "frontend"
    app_port = 80
    instance_type = "t3.small"
    min_size = 1
    max_size = 2
    desired_capacity = 1
    subnets_ref = "web"
    lb_ref = "public"
    lb_rule_priority = 100 # this will be separate LB so no need to use different rule
  }
}

kms_key_id = "arn:aws:kms:us-east-1:804838709963:key/7123afc2-b40f-4051-8098-22eef643474b"