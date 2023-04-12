terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.50.0"
    }
  }
  # backend "azurerm" {
  #   resource_group_name  = "Terraform_Terragrunt_Backend"
  #   storage_account_name = "tftgstoacc"
  #   container_name       = "tftgcontainer"
  #   key                  = "newstate.tfstate"
  # }
}

provider "azurerm" {
  features {}
}
