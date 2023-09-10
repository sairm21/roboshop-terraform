module "roboshop_instances" {
  source = "git::https://github.com/sairm21/terraform-module-app.git"
  component = each.key
  env =var.env
}