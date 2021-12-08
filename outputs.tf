output "vm_password" {
  description = "Local admin password of VM"
  value       = local.vm_password
  sensitive   = true
}

output "vm_ip" {
  description = "IP address of VM"
  value       = vsphere_virtual_machine.vm.default_ip_address
}
