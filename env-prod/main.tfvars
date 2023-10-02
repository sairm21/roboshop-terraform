env = "prod"

components= {
  Frontend ={
    tags = { Monitor = "True", Env = "Prod"}
  }
  MongoDB ={
    tags = {Env = "Prod"}
  }
  Catalogue ={
    tags = { Monitor = "True", Env = "Prod"}
  }
  Redis ={
    tags = {Env = "Prod"}
  }
  User ={
    tags = { Monitor = "True", Env = "Prod"}
  }
  Cart ={
    tags = { Monitor = "True", Env = "Prod"}
  }
  MySQL ={
    tags = {Env = "Prod"}
  }
  Shipping ={
    tags = { Monitor = "True", Env = "Prod"}
  }
  RabbitMQ ={
    tags = {Env = "Prod"}
  }
  Payment ={
    tags = { Monitor = "True", Env = "Prod"}
  }
  Dispatch ={
    tags = { Monitor = "True", Env = "Prod"}
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
    cidr_block       = "10.20.0.0/16"

    subnets = {
      web = {
        cidr_block = ["10.20.0.0/24", "10.20.1.0/24"]
      }
      app = {
        cidr_block = ["10.20.2.0/24", "10.20.3.0/24"]
      }
      db = {
        cidr_block = ["10.20.4.0/24", "10.20.5.0/24"]
      }
      Public = {
        cidr_block = ["10.20.6.0/24", "10.20.7.0/24"]
      }
    }
  }
}
