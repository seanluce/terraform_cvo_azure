# Configure the Azure and NetApp Cloud Manager providers
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
    netapp-cloudmanager = {
      source  = "NetApp/netapp-cloudmanager"
      version = ">= 21.5.3"
    }
  }
  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
}

provider "netapp-cloudmanager" {
  refresh_token = var.cm_refresh_token
}

# Create the NetApp Cloud Manager service connector resource group
resource "azurerm_resource_group" "cm_connector_rg" {
  name     = var.cm_connector_rg
  location = var.cm_connector_location
}

# Create the service connector's NSG
resource "azurerm_network_security_group" "cm_connector_nsg" {
  name                = "luces_cm_nsg"
  location            = var.cm_connector_location
  resource_group_name = azurerm_resource_group.cm_connector_rg.name
  security_rule {
    name                       = "http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "https"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "ssh"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Internet"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "netapp-cloudmanager_connector_azure" "cm_connector" {
  provider                    = netapp-cloudmanager
  name                        = var.cm_connector_name
  location                    = var.cm_connector_location
  subscription_id             = data.azurerm_subscription.azure_sub.subscription_id
  company                     = var.cm_company_name
  resource_group              = azurerm_resource_group.cm_connector_rg.name
  vnet_resource_group         = var.cm_vnet_rg
  vnet_id                     = var.cm_vnet_name
  subnet_id                   = var.cm_subnet_name
  network_security_group_name = azurerm_network_security_group.cm_connector_nsg.name
  associate_public_ip_address = true
  admin_username              = var.cm_username
  admin_password              = var.cm_password
  
}

data "azurerm_subscription" "azure_sub" {
}

data "azurerm_virtual_machine" "cm_connector_vm" {
  depends_on          = [netapp-cloudmanager_connector_azure.cm_connector]
  name                = var.cm_connector_name
  resource_group_name = azurerm_resource_group.cm_connector_rg.name
}

resource "azurerm_role_assignment" "cm_role_assignment" {
  scope              = data.azurerm_subscription.azure_sub.id
  role_definition_name = "Contributor"
  principal_id       = data.azurerm_virtual_machine.cm_connector_vm.identity.0.principal_id
}


resource "netapp-cloudmanager_cvo_azure" "cvo_azure_single" {
  depends_on = [azurerm_role_assignment.cm_role_assignment]
  provider               = netapp-cloudmanager
  name                   = var.cvo_name
  location               = var.cvo_location
  subscription_id        = var.azure_subid
  vnet_resource_group    = var.cvo_vnet_rg
  vnet_id                = var.cvo_vnet_name
  subnet_id              = var.cvo_subnet_name
  data_encryption_type   = "AZURE"
  azure_tag {
    tag_key   = "creator"
    tag_value = var.creator
  }
  azure_tag {
    tag_key   = "owner"
    tag_value = var.owner
  }
  storage_type        = "Premium_LRS"
  svm_password        = var.cvo_svm_password
  client_id           = netapp-cloudmanager_connector_azure.cm_connector.client_id
  #workspace_id        = "" # first workspace is selected or created if none is specified
  capacity_tier       = "Blob"
  writing_speed_state = "NORMAL"
  is_ha               = false
}
