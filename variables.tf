variable "prefix" {
  default = "shiva"
}

variable "CIDR" {
  default  = ["10.0.0.0/16"]
}

variable "location" {
  description = "The location/region where the core network will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
  default     = "westus2"
}



