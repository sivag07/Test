
resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}"
 #location = "West US 2"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "main" {
 #name                = "${var.prefix}-network"
  name                = "${var.network}"
  address_space       = "${var.CIDR}"
 #location            = "${azurerm_resource_group.main.location}"
  location            = "${var.location}" 
 #resource_group_name = "${azurerm_resource_group.main.name}"
  resource_group_name = "${var.prefix}" 
  
}


resource "azurerm_network_security_group" "main" {
  name                = "acceptanceTestSecurityGroup1"
 #name                = "{var.prefix}-nsg"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    }
}


resource "azurerm_subnet" "internal" {
  name                      = "internal"
  resource_group_name       = "${azurerm_resource_group.main.name}"
  virtual_network_name      = "${azurerm_virtual_network.main.name}"
  address_prefix            = "${var.subnet}"
  network_security_group_id = "${azurerm_network_security_group.main.id}"
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.internal.id}"
    private_ip_address_allocation = "Dynamic"
  }

}

/*
resource "azurerm_network_security_group" "main" {
  name                = "acceptanceTestSecurityGroup1"
 #name                = "{var.prefix}-nsg"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    }  
}
*/


resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = "${azurerm_resource_group.main.location}"
  resource_group_name   = "${azurerm_resource_group.main.name}"
  network_interface_ids = ["${azurerm_network_interface.main.id}"]
  vm_size               = "Standard_B1ls"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
  # name              = "myosdisk1"
    name              = "${var.prefix}-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "dev"
  }
}

/*

resource "azurerm_storage_account" "storageaccount" {
   name = "${var.storage-acc}"
   resource_group_name = "${azurerm_resource_group.main.name}"
   location = "${var.location}"
   account_tier = "Standard"
   account_replication_type = "GRS"
}
resource "azurerm_storage_container" "blobstorage" {
   name = "${var.storage-cont}"
   resource_group_name = "${azurerm_resource_group.main.name}"
   storage_account_name = "${azurerm_storage_account.storageaccount.name}"
   container_access_type = "blob"
}
resource "azurerm_storage_blob" "blobobject" {
   depends_on=  ["azurerm_storage_container.blobstorage"]
   name = "index.html"
   resource_group_name = "${azurerm_resource_group.main.name}"
   storage_account_name = "${azurerm_storage_account.storageaccount.name}"
   storage_container_name = "${azurerm_storage_container.blobstorage.name}"
   source="./index.html"

}

output "url" {
   value = "http://${azurerm_storage_account.storageaccount.name}.blob.core.windows.net/${azurerm_storage_container.blobstorage.name}/index.html"
}

*/

