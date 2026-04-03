output "vm_id" {
  description = "Proxmox VM ID"
  value       = proxmox_virtual_environment_vm.accommap.vm_id
}

output "vm_ipv4" {
  description = "VM IPv4 address reported by the guest agent"
  value       = proxmox_virtual_environment_vm.accommap.ipv4_addresses
}

output "app_url" {
  description = "AccomMap frontend URL (substitute IP if DHCP)"
  value       = "http://${proxmox_virtual_environment_vm.accommap.ipv4_addresses[1][0]}:3000"
}

output "api_url" {
  description = "AccomMap API / Swagger URL"
  value       = "http://${proxmox_virtual_environment_vm.accommap.ipv4_addresses[1][0]}:8000/docs"
}
