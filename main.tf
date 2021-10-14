# Configure the Azure and NetApp Cloud Manager providers
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.46.0"
    }
    netapp-cloudmanager = {
      source  = "NetApp/netapp-cloudmanager"
      version = ">= 21.9.4"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "netapp-cloudmanager" {
  refresh_token = var.cm_refresh_token
}

data "azurerm_subscription" "azure_sub" {
}

# Create the custom role definition based on 
resource "azurerm_role_definition" "cm_custom_role" {
  name        = "NetApp Custom Role"
  scope       = data.azurerm_subscription.azure_sub.id
  description = "This is a custom role created via Terraform for NetApp Cloud Manager"

  permissions {
    actions     = ["Microsoft.Compute/disks/delete",
                        "Microsoft.Compute/disks/read",
                        "Microsoft.Compute/disks/write",
                        "Microsoft.Compute/locations/operations/read",
                        "Microsoft.Compute/locations/vmSizes/read",
                        "Microsoft.Resources/subscriptions/locations/read",
                        "Microsoft.Compute/operations/read",
                        "Microsoft.Compute/virtualMachines/instanceView/read",
                        "Microsoft.Compute/virtualMachines/powerOff/action",
                        "Microsoft.Compute/virtualMachines/read",
                        "Microsoft.Compute/virtualMachines/restart/action",
                        "Microsoft.Compute/virtualMachines/deallocate/action",
                        "Microsoft.Compute/virtualMachines/start/action",
                        "Microsoft.Compute/virtualMachines/vmSizes/read",
                        "Microsoft.Compute/virtualMachines/write",
                        "Microsoft.Compute/images/write",
                        "Microsoft.Compute/images/read",
                        "Microsoft.Network/locations/operationResults/read",
                        "Microsoft.Network/locations/operations/read",
                        "Microsoft.Network/networkInterfaces/read",
                        "Microsoft.Network/networkInterfaces/write",
                        "Microsoft.Network/networkInterfaces/join/action",
                        "Microsoft.Network/networkSecurityGroups/read",
                        "Microsoft.Network/networkSecurityGroups/write",
                        "Microsoft.Network/networkSecurityGroups/join/action",
                        "Microsoft.Network/virtualNetworks/read",
                        "Microsoft.Network/virtualNetworks/checkIpAddressAvailability/read",
                        "Microsoft.Network/virtualNetworks/subnets/read",
                        "Microsoft.Network/virtualNetworks/subnets/write",
                        "Microsoft.Network/virtualNetworks/subnets/virtualMachines/read",
                        "Microsoft.Network/virtualNetworks/virtualMachines/read",
                        "Microsoft.Network/virtualNetworks/subnets/join/action",
                        "Microsoft.Resources/deployments/operations/read",
                        "Microsoft.Resources/deployments/read",
                        "Microsoft.Resources/deployments/write",
                        "Microsoft.Resources/resources/read",
                        "Microsoft.Resources/subscriptions/operationresults/read",
                        "Microsoft.Resources/subscriptions/resourceGroups/delete",
                        "Microsoft.Resources/subscriptions/resourceGroups/read",
                        "Microsoft.Resources/subscriptions/resourcegroups/resources/read",
                        "Microsoft.Resources/subscriptions/resourceGroups/write",
                        "Microsoft.Storage/checknameavailability/read",
                        "Microsoft.Storage/operations/read",
                        "Microsoft.Storage/storageAccounts/listkeys/action",
                        "Microsoft.Storage/storageAccounts/read",
                        "Microsoft.Storage/storageAccounts/delete",
                        "Microsoft.Storage/storageAccounts/regeneratekey/action",
                        "Microsoft.Storage/storageAccounts/write",
                        "Microsoft.Storage/storageAccounts/blobServices/containers/read",
                        "Microsoft.Storage/usages/read",
                        "Microsoft.Compute/snapshots/write",
                        "Microsoft.Compute/snapshots/read",
                        "Microsoft.Compute/availabilitySets/write",
                        "Microsoft.Compute/availabilitySets/read",
                        "Microsoft.Compute/disks/beginGetAccess/action",
                        "Microsoft.MarketplaceOrdering/offertypes/publishers/offers/plans/agreements/read",
                        "Microsoft.MarketplaceOrdering/offertypes/publishers/offers/plans/agreements/write",
                        "Microsoft.Network/loadBalancers/read",
                        "Microsoft.Network/loadBalancers/write",
                        "Microsoft.Network/loadBalancers/delete",
                        "Microsoft.Network/loadBalancers/backendAddressPools/read",
                        "Microsoft.Network/loadBalancers/backendAddressPools/join/action",
                        "Microsoft.Network/loadBalancers/frontendIPConfigurations/read",
                        "Microsoft.Network/loadBalancers/loadBalancingRules/read",
                        "Microsoft.Network/loadBalancers/probes/read",
                        "Microsoft.Network/loadBalancers/probes/join/action",
                        "Microsoft.Authorization/locks/*",
                        "Microsoft.Network/routeTables/join/action",
                        "Microsoft.NetApp/netAppAccounts/read",
                        "Microsoft.NetApp/netAppAccounts/capacityPools/read",
                        "Microsoft.NetApp/netAppAccounts/capacityPools/volumes/write",
                        "Microsoft.NetApp/netAppAccounts/capacityPools/volumes/read",
                        "Microsoft.NetApp/netAppAccounts/capacityPools/volumes/delete",
                        "Microsoft.Network/privateEndpoints/write",
                        "Microsoft.Storage/storageAccounts/PrivateEndpointConnectionsApproval/action",
                        "Microsoft.Storage/storageAccounts/privateEndpointConnections/read",
                        "Microsoft.Storage/storageAccounts/managementPolicies/read",
                        "Microsoft.Storage/storageAccounts/managementPolicies/write",
                        "Microsoft.Network/privateEndpoints/read",
                        "Microsoft.Network/privateDnsZones/write",
                        "Microsoft.Network/privateDnsZones/virtualNetworkLinks/write",
                        "Microsoft.Network/virtualNetworks/join/action",
                        "Microsoft.Network/privateDnsZones/A/write",
                        "Microsoft.Network/privateDnsZones/read",
                        "Microsoft.Network/privateDnsZones/virtualNetworkLinks/read",
                        "Microsoft.Resources/deployments/operationStatuses/read",
                        "Microsoft.Insights/Metrics/Read",
                        "Microsoft.Compute/virtualMachines/extensions/write",
                        "Microsoft.Compute/virtualMachines/extensions/delete",
                        "Microsoft.Compute/virtualMachines/extensions/read",
                        "Microsoft.Compute/virtualMachines/delete",
                        "Microsoft.Network/networkInterfaces/delete",
                        "Microsoft.Network/networkSecurityGroups/delete",
                        "Microsoft.Resources/deployments/delete",
                        "Microsoft.Compute/diskEncryptionSets/read",
                        "Microsoft.Compute/snapshots/delete",
                        "Microsoft.Network/privateEndpoints/delete",
                        "Microsoft.Compute/availabilitySets/delete",
                        "Microsoft.Network/loadBalancers/delete",
                        "Microsoft.KeyVault/vaults/read",
                        "Microsoft.KeyVault/vaults/accessPolicies/write",
                        "Microsoft.Compute/diskEncryptionSets/write",
                        "Microsoft.KeyVault/vaults/deploy/action",
                        "Microsoft.Compute/diskEncryptionSets/delete",
                        "Microsoft.Resources/tags/read",
                        "Microsoft.Resources/tags/write",
                        "Microsoft.Resources/tags/delete"]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.azure_sub.id
  ]
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

data "azurerm_virtual_machine" "cm_connector_vm" {
  depends_on          = [netapp-cloudmanager_connector_azure.cm_connector]
  name                = var.cm_connector_name
  resource_group_name = azurerm_resource_group.cm_connector_rg.name
}

resource "azurerm_role_assignment" "cm_role_assignment" {
  scope              = data.azurerm_subscription.azure_sub.id
  role_definition_id = azurerm_role_definition.cm_custom_role.id
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
