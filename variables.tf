variable "prefix" {
  default = "shiva-RG"
}

variable "network" {
  description = "virtual network"
  default     = "shiva-RG"
}

variable "CIDR" {
  default  = ["10.0.0.0/16"]
}

variable "location" {
  description = "The location/region where the core network will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
  default     = "westus2"
}

variable "subnet" {
  default  = "10.0.2.0/24"
}

/*
variable "nsg" {
  description = "network_security_group"
  default     = "shiva-RG"
}
*/

variable "os-disk" {
  description = "Storage_os_disk"
  default     = "shiva-RG"
}

variable "storage-acc" {
  description = "azurerm_sa_name"
  default     = "shiva-RG"
}

variable "storage-cont" {
  description = "azurerm_storage_container_name"
  default     = "shiva-RG"
}


