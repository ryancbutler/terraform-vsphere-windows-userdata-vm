variable "vsphere_datacenter" {
  description = "vsphere datacenter"
  type        = string
}

variable "vsphere_datastore" {
  description = "vsphere datastore to deploy"
  type        = string
}

variable "vsphere_rp" {
  description = "vsphere resource pool"
  type        = string
}

variable "vsphere_template" {
  description = "vsphere template name or vm to clone"
  type        = string
}

variable "vm_network" {
  description = "vsphere network for deployed vm"
  type        = string
}

variable "vm_cpu" {
  description = "Number of CPUS to assign to VM"
  type        = number
  default     = 2
}

variable "vm_memory" {
  description = "Amount of RAM to assign to VM (IN MB)"
  type        = number
  default     = 4096
}

variable "vm_dns_domain" {
  description = "DNS Domain"
  type        = string
}

variable "vm_dns_servers" {
  description = "DNS Servers to use"
  type        = list(string)
}

variable "vm_ip" {
  description = "IP of linux VM"
  type        = string
}

variable "vm_gateway" {
  description = "Gateway of linux VM"
  type        = string
}

variable "vm_netmask" {
  description = "Subnet mask of VM network"
  type        = number
}

variable "vm_annotation" {
  description = "Note to apply to VM"
  type        = string
  default     = "BUILT BY TERRAFORM"
}

variable "vm_thinprov" {
  description = "Thin provision OS disk?"
  type        = bool
  default     = true
}

variable "vm_disk_size" {
  description = "Disk size for OS disk (IN GB)"
  type        = number
  default     = 60
}

variable "vm_name" {
  description = "Name for linux VM"
  type        = string
}

variable "vm_password" {
  description = "Password for linux VM (LEAVE BLANK TO GENERATE)"
  default     = ""
  sensitive   = true
  type        = string
}

variable "vm_folder" {
  description = "Folder path to place VM"
  type        = string
  default     = null
}

variable "vm_disks" {
  description = "List of extra disks to create"
  type = map(object({
    size        = number
    thinprov    = bool
    unit_number = number
  }))
  default = {}
}
variable "vm_timezone" {
  description = "TimeZone to use for deployed machines (DEFAULT CENTRAL)"
  type        = number
  default     = "020"
}

# used to join the domain
variable "ADDomain" {
  type        = string
  description = "Domain to join."
}
variable "ADOU" {
  type        = string
  description = "Which OU to place the server in"
}
variable "ADUser" {
  type        = string
  description = "Login info to join domain"
}
variable "ADPass" {
  type        = string
  description = "Password info to join domain"
  sensitive   = true
}
