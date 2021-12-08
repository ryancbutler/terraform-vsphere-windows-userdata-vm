output "vm_password" {
  description = "Local admin password of VM"
  value       = nonsensitive(module.windows_vm.vm_password)
}

output "vm_ip" {
  description = "IP address of VM"
  value       = module.windows_vm.vm_ip
}
