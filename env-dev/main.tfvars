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
  Company_name="SRK India Pvt Ltd.,"
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

kms_key_id = "arn:aws:kms:us-east-1:804838709963:key/7123afc2-b40f-4051-8098-22eef643474b"