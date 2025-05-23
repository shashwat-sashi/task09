variable "location" {
  type = string
}

variable "resource_group" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "aks_subnet_name" {
  type = string
}

variable "resource_prefix" {
  type = string
}

variable "aks_loadbalancer_ip" {
  description = "Public IP of AKS Load Balancer"
  type        = string
}