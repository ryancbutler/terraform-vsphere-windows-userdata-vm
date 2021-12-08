provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

module "windows_vm" {
  source = "../.."
  #Where to place the VM
  vsphere_datacenter = "DC01"
  vsphere_datastore  = "NUC01"
  #Resource Pool (If no resource pool place in CLUSTER/Resources format)
  vsphere_rp       = "LAB/Resources"
  vsphere_template = "windows2019"

  #VM naming
  vm_name     = "windows-test02"
  vm_password = "P@ssword123"
  #Networking info
  vm_network     = "VLAN2"
  vm_ip          = "192.168.2.56"
  vm_gateway     = "192.168.2.254"
  vm_dns_domain  = "lab.local"
  vm_dns_servers = ["192.168.2.4"]
  vm_netmask     = 24

  #Join domain
  ADDomain = var.ADDomain
  ADOU     = var.ADOU
  ADUser   = var.ADUser
  ADPass   = var.ADPass
}
