terraform {
  required_version = ">= 1.0.0"
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.0.2"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0"
    }
    template = {
      source  = "hashicorp/template"
      version = ">= 2.2.0"
    }
  }
}

locals {
  vm_password = var.vm_password == "" ? random_password.password.result : var.vm_password
}

data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = var.vsphere_rp
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vsphere_template
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vm_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "random_password" "password" {
  length           = 8
  special          = true
  min_numeric      = 1
  min_special      = 1
  override_special = "!@$"
}

data "template_file" "init" {
  template = file("${path.module}/templates/bootstrap.ps1")
  vars = {
    adpass   = var.ADPass
    adou     = var.ADOU
    aduser   = var.ADUser
    addomain = var.ADDomain
  }
}

#Not used but could be another location to store data
data "template_file" "metadata" {
  template = file("${path.module}/templates/metadata.yaml")
  vars = {

  }
}

resource "vsphere_virtual_machine" "vm" {
  name             = var.vm_name
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = var.vm_folder
  num_cpus         = var.vm_cpu
  memory           = var.vm_memory
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  annotation       = var.vm_annotation
  scsi_type        = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  cdrom {
    client_device = true
  }

  disk {
    label            = "os"
    size             = var.vm_disk_size
    thin_provisioned = var.vm_thinprov
  }

  dynamic "disk" {
    for_each = var.vm_disks
    content {
      label            = disk.key
      size             = disk.value["size"]
      eagerly_scrub    = false
      thin_provisioned = disk.value["thinprov"]
      unit_number      = disk.value["unit_number"]
    }
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    linked_clone  = false
    customize {
      windows_options {
        computer_name    = var.vm_name
        admin_password   = var.vm_password == "" ? random_password.password.result : var.vm_password
        workgroup        = "WORKGROUP"
        auto_logon       = true
        auto_logon_count = 1
        time_zone        = var.vm_timezone
        run_once_command_list = [
          "powershell \"cd \"$env:ProgramFiles\\VMware\\VMware~1\";[System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($(.\\rpctool.exe \\\"info-get guestinfo.userdata\\\")))|out-file C:\\bootstrap.ps1\"",
          "cmd.exe /C Powershell.exe -ExecutionPolicy Bypass -File C:\\bootstrap.ps1"
        ]

      }

      network_interface {
        ipv4_address    = var.vm_ip
        ipv4_netmask    = var.vm_netmask
        dns_server_list = var.vm_dns_servers
        dns_domain      = var.vm_dns_domain
      }

      ipv4_gateway = var.vm_gateway
    }
  }

  #https://discuss.hashicorp.com/t/proper-format-for-adding-nic-to-host-during-cloning/6494
  extra_config = {
    "ethernet1.virtualDev"        = "vmxnet3"
    "ethernet1.present"           = "TRUE"
    "guestinfo.metadata"          = base64encode(data.template_file.metadata.rendered)
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = base64encode(data.template_file.init.rendered)
    "guestinfo.userdata.encoding" = "base64"
  }


  lifecycle {
    ignore_changes = [
      extra_config
    ]
  }

}


