provider "azurerm" {
  features {}
}

module "example_module" {

    source  = "CheckPointSW/cloudguard-network-security/azure//modules/management_new_vnet"
    version = "1.0.4"


    source_image_vhd_uri            = "noCustomUri"
    resource_group_name             = "cpman-tf-${local.envId}"
    mgmt_name                       = "cpman"
    # sweden azure region
    location                        =  "Sweden Central"
    vnet_name                       = "cpman"
    address_space                   = "172.16.0.0/16"
    subnet_prefix                   = "172.16.68.0/24"
    management_GUI_client_network   = "0.0.0.0/0"
    mgmt_enable_api                 = "all"
    admin_password                  = var.cpadmin_password
    vm_size                         = "Standard_D3_v2" # 4 vCPU, 14GB RAM
    disk_size                       = "110"
    vm_os_sku                       = "mgmt-byol"
    vm_os_offer                     = "check-point-cg-r8120"
    os_version                      = "R8120"
    bootstrap_script                = "touch /home/admin/bootstrap.txt; echo 'hello_world' > /home/admin/bootstrap.txt"
    allow_upload_download           = true
    authentication_type             = "Password"
    admin_shell                     = "/bin/bash"
    serial_console_password_hash    = "" # openssl passwd -6 PASSWORD
    maintenance_mode_password_hash  = "" # grub2-mkpasswd-pbkdf2
    nsg_id                          = ""
    add_storage_account_ip_rules    = false
    storage_account_additional_ips  = []
}