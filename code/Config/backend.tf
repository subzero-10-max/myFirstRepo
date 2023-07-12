terraform {
  backend "azurerm" {
    resource_group_name = "talha_terraform_backend"
    storage_account_name = "talhaterraformbackend10"
    container_name = "terraform-backend"
    key = "terraform.tfstate"
  }
}
