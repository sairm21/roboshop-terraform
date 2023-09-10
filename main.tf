module "roboshop_instances" {
  for_each = var.component
  source = "git::https://github.com/sairm21/terraform-module-app.git"
  component= each.key
  env =var.env
}