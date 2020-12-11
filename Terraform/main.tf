provider "azurerm" {
    subscription_id = var.SUBSCRIPTIONID
    client_id = var.APPID
    client_secret = var.APPSECRET
    tenant_id = var.TENANTID
    features { 
    }
}

resource "azurerm_resource_group" "rg" {
    name = "CTPSSERJE001"
    location = "Canada Central"

    tags = {
        BUILDING_BLOCK = "Terraform"
        DEPLOYMENT_ID = "QBE0MJ"
        ENVIRONMENT = "DEVELOP"
        OWNER = "testapp4life1986@outlook.com"
        PRODUCT_APP = "MyTestResources"
    }
}

resource "azurerm_network_security_group" "nsg01" {
    name = "nsgTest01"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    security_rule = [ {
      access = "Allow"
      description = "SSH Traffic"
      destination_address_prefix = "174.91.158.104"
      destination_address_prefixes = null
      destination_application_security_group_ids = null
      destination_port_range = "22"
      destination_port_ranges = null
      direction = "Inbound"
      name = "AllowSSH"
      priority = 100
      protocol = "Tcp"
      source_address_prefix = "174.91.158.103"
      source_address_prefixes = null
      source_application_security_group_ids = null
      source_port_range = "*"
      source_port_ranges = null
    },
    {
      access = "Allow"
      description = "HTTPS Traffic"
      destination_address_prefix = null
      destination_address_prefixes = null
      destination_application_security_group_ids = [azurerm_application_security_group.appSecGroup.id]
      destination_port_range = "443"
      destination_port_ranges = null
      direction = "Inbound"
      name = "AllowHTTPS"
      priority = 105
      protocol = "Tcp"
      source_address_prefix = "*"
      source_address_prefixes = null
      source_application_security_group_ids = null
      source_port_range = "*"
      source_port_ranges = null
    },
    {
      access = "Allow"
      description = "SSH From VM1 Traffic"
      destination_address_prefix = null
      destination_address_prefixes = null
      destination_application_security_group_ids = [azurerm_application_security_group.appSecGroup.id]
      destination_port_range = "22"
      destination_port_ranges = null
      direction = "Inbound"
      name = "AllowSSHFromVM1"
      priority = 106
      protocol = "Tcp"
      source_address_prefix = "174.91.158.104"
      source_address_prefixes = null
      source_application_security_group_ids = null
      source_port_range = "*"
      source_port_ranges = null
    },
    {
      access = "Deny"
      description = "Deny Inconming traffic"
      destination_address_prefix = null
      destination_address_prefixes = null
      destination_application_security_group_ids = [azurerm_application_security_group.appSecGroup.id]
      destination_port_range = "*"
      destination_port_ranges = null
      direction = "Inbound"
      name = "DenyAllInboundCustom"
      priority = 200
      protocol = "*"
      source_address_prefix = "*"
      source_address_prefixes = null
      source_application_security_group_ids = null
      source_port_range = "*"
      source_port_ranges = null
    }]
}

resource "azurerm_virtual_network" "principal" {
    name = "virtualNetworkTest01"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    address_space = ["174.91.0.0/16"]
    dns_servers = ["174.0.0.4", "174.0.0.5"]

    tags = {
        BUILDING_BLOCK = "Terraform"
        DEPLOYMENT_ID = "QBE0MJ"
        ENVIRONMENT = "DEVELOP"
        OWNER = "testapp4life1986@outlook.com"
        PRODUCT_APP = "MyTestResources"
    }
}

resource "azurerm_subnet" "sub01" {
  name = "subnetTest01"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.principal.name
  address_prefixes = ["174.91.158.0/24"]
}

//Public IP VMs
resource "azurerm_public_ip" "pi01VM01" {
    name = "publicIpVM01"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    allocation_method   = "Static"

    tags = {
        BUILDING_BLOCK = "Terraform"
        DEPLOYMENT_ID = "QBE0MJ"
        ENVIRONMENT = "DEVELOP"
        OWNER = "testapp4life1986@outlook.com"
        PRODUCT_APP = "MyTestResources"
    }
}

resource "azurerm_public_ip" "pi01VM02" {
    name = "publicIpVM02"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    allocation_method   = "Static"

    tags = {
        BUILDING_BLOCK = "Terraform"
        DEPLOYMENT_ID = "QBE0MJ"
        ENVIRONMENT = "DEVELOP"
        OWNER = "testapp4life1986@outlook.com"
        PRODUCT_APP = "MyTestResources"
    }
}

resource "azurerm_public_ip" "pi01VM03" {
    name = "publicIpVM03"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    allocation_method   = "Static"

    tags = {
        BUILDING_BLOCK = "Terraform"
        DEPLOYMENT_ID = "QBE0MJ"
        ENVIRONMENT = "DEVELOP"
        OWNER = "testapp4life1986@outlook.com"
        PRODUCT_APP = "MyTestResources"
    }
}

//Virtual NICs VMs
resource "azurerm_network_interface" "networkVMInterface01" {
    name = "vnic01"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
        name = "vnicInternal01"
        subnet_id = azurerm_subnet.sub01.id
        private_ip_address_allocation = "static"
        private_ip_address = "174.91.158.104"
        public_ip_address_id = azurerm_public_ip.pi01VM01.id
    }    
}

resource "azurerm_network_interface" "networkVMInterface02" {
    name = "vnic02"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
        name = "vnicInternal02"
        subnet_id = azurerm_subnet.sub01.id
        private_ip_address_allocation = "static"
        private_ip_address = "174.91.158.103"
        public_ip_address_id = azurerm_public_ip.pi01VM02.id
    }    
}

resource "azurerm_network_interface" "networkVMInterface03" {
    name = "vnic03"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
        name = "vnicInternal03"
        subnet_id = azurerm_subnet.sub01.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.pi01VM03.id
    }    
}

//NSA Assignation

resource "azurerm_application_security_group" "appSecGroup" {
  name                = "networkASG01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_interface_application_security_group_association" "ngasignation02" {
  network_interface_id          = azurerm_network_interface.networkVMInterface02.id
  application_security_group_id = azurerm_application_security_group.appSecGroup.id
}

resource "azurerm_network_interface_application_security_group_association" "ngasignation03" {
  network_interface_id          = azurerm_network_interface.networkVMInterface03.id
  application_security_group_id = azurerm_application_security_group.appSecGroup.id
}

//Creation VMs
resource "azurerm_linux_virtual_machine" "vm01" {
    name = "linuxVM01"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    size = "Standard_F2"
    admin_username = "adminuser"
    network_interface_ids = [
        azurerm_network_interface.networkVMInterface01.id
    ]

    admin_ssh_key {
        username = "adminuser"
        public_key = file("~/.ssh/id_rsa.pub")
    }

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer = "UbuntuServer"
        sku = "16.04-LTS"
        version = "latest"
    }

    tags = {
        BUILDING_BLOCK = "Terraform"
        DEPLOYMENT_ID = "QBE0MJ"
        ENVIRONMENT = "DEVELOP"
        OWNER = "testapp4life1986@outlook.com"
        PRODUCT_APP = "MyTestResources"
        VMNAME  = "VM01"
    }    
    
}

resource "azurerm_linux_virtual_machine" "vm02" {
    name = "linuxVM02"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    size = "Standard_F2"
    admin_username = "adminuser"
    network_interface_ids = [
        azurerm_network_interface.networkVMInterface02.id
    ]

    admin_ssh_key {
        username = "adminuser"
        public_key = file("~/.ssh/id_rsa.pub")
    }

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer = "UbuntuServer"
        sku = "16.04-LTS"
        version = "latest"
    }

    tags = {
        BUILDING_BLOCK = "Terraform"
        DEPLOYMENT_ID = "QBE0MJ"
        ENVIRONMENT = "DEVELOP"
        OWNER = "testapp4life1986@outlook.com"
        PRODUCT_APP = "MyTestResources"
        VMNAME  = "VM02"
    }    
    
}

resource "azurerm_linux_virtual_machine" "vm03" {
    name = "linuxVM03"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    size = "Standard_F2"
    admin_username = "adminuser"
    network_interface_ids = [
        azurerm_network_interface.networkVMInterface03.id
    ]

    admin_ssh_key {
        username = "adminuser"
        public_key = file("~/.ssh/id_rsa.pub")
    }

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer = "UbuntuServer"
        sku = "16.04-LTS"
        version = "latest"
    }

    tags = {
        BUILDING_BLOCK = "Terraform"
        DEPLOYMENT_ID = "QBE0MJ"
        ENVIRONMENT = "DEVELOP"
        OWNER = "testapp4life1986@outlook.com"
        PRODUCT_APP = "MyTestResources"
        VMNAME  = "VM03"
    }        
}
