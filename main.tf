module "roboshop_instances" {
  for_each = var.components
  source = "git::https://github.com/sairm21/terraform-module-app.git"
  component= each.key
  env =var.env
}