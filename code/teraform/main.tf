module "acr" {
  source = "git::https://github.com/DevOps-Guy01/priv_module.git"

  resource_group_name = var.resource_group_name
  location            = var.location

  acr_name = var.acr_name
  acr_sku  = var.acr_sku

  tags = var.tags
}
#sdghmsd
