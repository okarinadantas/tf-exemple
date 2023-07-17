provider "azurerm" {
  features {}
}

resource "azurerm_subscription" "example" {
  display_name = "subscription-01"
}

resource "azurerm_resource_group" "example" {
  name     = "rg-01"
  location = "Brazil South"
  tags     = {
    environment = "Dev"
  }
}

resource "azurerm_key_vault" "example" {
  name                = "kv-01"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku_name            = "standard"
  tenant_id           = azurerm_subscription.example.tenant_id

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  tags = {
    environment = "Dev"
  }
}

resource "azurerm_redis_cache" "example" {
  name                     = "bd-redis-01"
  location                 = azurerm_resource_group.example.location
  resource_group_name      = azurerm_resource_group.example.name
  capacity                 = 1
  family                   = "C"
  sku_name                 = "Standard"
  enable_non_ssl_port      = false
  minimum_tls_version      = "1.2"
  subnet_id                = azurerm_subnet.example.id
  private_endpoint_enabled = true
  private_endpoint {
    subnet_id                     = azurerm_subnet.example.id
    private_service_connection_id = azurerm_private_endpoint_connection.example.id
  }

  tags = {
    environment = "Dev"
  }
}

resource "azurerm_subnet" "example" {
  name                 = "bd-subnet-01"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_private_endpoint" "example" {
  name                = "bd-pvt-01"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  subnet_id           = azurerm_subnet.example.id

  private_service_connection {
    name                           = "pvt-service-connection"
    private_connection_resource_id = azurerm_redis_cache.example.id
    subresource_names              = ["redis"]
  }

  dns_zone {
    name            = "privatelink.redis.cache.azure.net"
    private_dns_zone_id = data.azurerm_private_dns_zone.example.id
  }
}

data "azurerm_private_dns_zone" "example" {
  name                = "privatelink.redis.cache.azure.net."
  resource_group_name = azurerm_resource_group.example.name
}
