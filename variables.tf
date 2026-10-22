variable "location" {
  type = string
}

variable "prefix" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "vm_size" {
  type = string
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}


variable "admin_password" {
  type      = string
  sensitive = true
}

variable "vnet_address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "web_subnet_prefix" {
  type    = string
  default = "10.0.1.0/24"
}

variable "app_subnet_prefix" {
  type    = string
  default = "10.0.2.0/24"
}

variable "db_subnet_prefix" {
  type    = string
  default = "10.0.3.0/24"
}
