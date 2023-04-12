module "acr" {
  source = "git::https://github.com/subzero-10-max/priv.git//modules"

  resource_group_name = var.resource_group_name
  location            = var.location

  acr_name = var.acr_name
  acr_sku  = var.acr_sku

  tags = var.tags
}
