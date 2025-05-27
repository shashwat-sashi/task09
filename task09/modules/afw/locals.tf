locals {
  firewall_name        = format("%s-afw", var.prefix)
  firewall_subnet_name = "AzureFirewallSubnet"
  route_table_name     = format("%s-rt", var.prefix)
  public_ip_name       = format("%s-pip", var.prefix)
  default_route_name   = format("%s-default-route", var.prefix)
  firewall_pip_route_name = format("%s-firewall-pip", local.default_route_name)

  network_rules = [
    {
      name                  = "AllowHTTP"
      protocols             = ["TCP"]
      source_addresses      = ["*"]
      destination_ports     = ["80"]
      destination_addresses = ["*"]
    },
    {
      name                  = "Allow8080"
      protocols             = ["TCP"]
      source_addresses      = ["*"]
      destination_ports     = ["8080"]
      destination_addresses = [var.aks_loadbalancer_ip]
    },
    {
      name                  = "AllowDNATReturn"
      protocols             = ["TCP"]
      source_addresses      = ["*"]
      destination_ports     = ["80", "443", "8080"]
      destination_addresses = [var.aks_loadbalancer_ip]
    },
    {
      name                  = "AllowHTTPS"
      protocols             = ["TCP"]
      source_addresses      = ["*"]
      destination_ports     = ["443"]
      destination_addresses = ["*"]
    },
    {
      name                  = "AllowDNS"
      protocols             = ["UDP"]
      source_addresses      = ["*"]
      destination_ports     = ["53"]
      destination_addresses = ["*"]
    },
    {
      name                  = "AllowKubernetes"
      protocols             = ["TCP"]
      source_addresses      = ["*"]
      destination_ports     = ["6443", "10250", "10251", "10252", "2379", "2380"]
      destination_addresses = ["*"]
    },
    {
      name                  = "AllowNTP"
      protocols             = ["UDP"]
      source_addresses      = ["*"]
      destination_ports     = ["123"]
      destination_addresses = ["*"]
    },
    {
      name                  = "AllowICMP"
      protocols             = ["ICMP"]
      source_addresses      = ["*"]
      destination_ports     = ["*"]
      destination_addresses = ["*"]
    }
  ]

  application_rules = [
    {
      name             = "AllowAzureServices"
      source_addresses = ["*"]
      protocols = [
        {
          port = 443
          type = "Https"
        },
        {
          port = 80
          type = "Http"
        }
      ]
      target_fqdns = [
        "*.azure.com",
        "*.microsoft.com",
        "*.windows.net",
        "*.azurecr.io",
        "*.blob.core.windows.net",
        "*.vault.azure.net",
        "*.azmk8s.io",
        # Fixed: Removed "*.hcp.*.azmk8s.io" and added specific regional endpoints
        "*.hcp.eastus.azmk8s.io",
        "*.hcp.westus2.azmk8s.io",
        "*.hcp.centralus.azmk8s.io",
        "*.hcp.northeurope.azmk8s.io",
        "*.hcp.westeurope.azmk8s.io",
        "*.hcp.southeastasia.azmk8s.io",
        "*.hcp.japaneast.azmk8s.io",
        "*.hcp.australiaeast.azmk8s.io",
        # Add more regions as needed for your deployment
        "mcr.microsoft.com",
        "*.data.mcr.microsoft.com",
        "management.azure.com",
        "login.microsoftonline.com",
        "packages.microsoft.com",
        "acs-mirror.azureedge.net"
      ]
    },
    {
      name             = "AllowContainerRegistry"
      source_addresses = ["*"]
      protocols = [
        {
          port = 443
          type = "Https"
        }
      ]
      target_fqdns = [
        "*.docker.io",
        "*.docker.com",
        "registry-1.docker.io",
        "auth.docker.io",
        "production.cloudflare.docker.com",
        "quay.io",
        "*.quay.io",
        "gcr.io",
        "*.gcr.io",
        "k8s.gcr.io",
        "*.k8s.io"
      ]
    },
    {
      name             = "AllowUbuntuPackages"
      source_addresses = ["*"]
      protocols = [
        {
          port = 443
          type = "Https"
        },
        {
          port = 80
          type = "Http"
        }
      ]
      target_fqdns = [
        "*.ubuntu.com",
        "*.canonical.com",
        "archive.ubuntu.com",
        "security.ubuntu.com",
        "changelogs.ubuntu.com",
        "*.launchpad.net",
        # Additional Ubuntu mirrors
        "azure.archive.ubuntu.com"
      ]
    },
    {
      name             = "AllowGeneralWeb"
      source_addresses = ["*"]
      protocols = [
        {
          port = 443
          type = "Https"
        },
        {
          port = 80
          type = "Http"
        }
      ]
      target_fqdns = ["*"]
    }
  ]


}