output "external_ip_address_vm_1" {
  value = ah_cloud_server.example.*.ips.0.ip_address
}