provider "azurerm" {
  features {}
}

module "example_module" {

  source  = "CheckPointSW/cloudguard-network-security/azure//modules/single_gateway_new_vnet"
  version = "1.0.4"

  source_image_vhd_uri            = "noCustomUri"
  resource_group_name             = "demo-gw2"
  single_gateway_name             = "gw"
  location                        = "westeurope"
  vnet_name                       = "gw2"
  address_space                   = "10.68.0.0/16"
  frontend_subnet_prefix          = "10.68.1.0/24"
  backend_subnet_prefix           = "10.68.2.0/24"
  management_GUI_client_network   = "0.0.0.0/0"
  admin_password                  = "HelloAutomagic###"
  smart_1_cloud_token             = ""
  sic_key                         = "helloautomagic123"
  vm_size                         = "Standard_D3_v2"
  disk_size                       = "110"
  vm_os_sku                       = "sg-byol"
  vm_os_offer                     = "check-point-cg-r82"
  os_version                      = "R82"
  bootstrap_script                = "touch /home/admin/bootstrap.txt; echo 'hello_world' > /home/admin/bootstrap.txt"
  allow_upload_download           = true
  authentication_type             = "Password"
  enable_custom_metrics           = true
  admin_shell                     = "/bin/bash"
  installation_type               = "gateway"
  serial_console_password_hash    = ""
  maintenance_mode_password_hash  = ""
  nsg_id                          = ""
  add_storage_account_ip_rules    = false
  storage_account_additional_ips  = []
}