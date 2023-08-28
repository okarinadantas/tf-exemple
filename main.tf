provider "azurerm" {
  features {}
}

module "my_resource_group" {
  source            = "git::https://github.com/okarinadantas/module-tf/blob/main/azure/"
  resource_group_name = locals.resource_group_name
  location          = locals.location
  tags     = var.tags
}

