resource "local_file" "AnsibleInventory" {
  content = templatefile("inventory.tpl",
    {
      ip = ah_cloud_server.example.*.ips.0.ip_address
    }
  )
  filename = "hosts"

  provisioner "local-exec" {
    command = "ansible-playbook -u adminroot -i hosts ansible/provision.yml"
   }
}