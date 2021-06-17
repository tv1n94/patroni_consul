resource "ah_private_network" "example" {
  ip_range = "192.168.2.0/24"
  name     = "LAN for cluster1"
}

resource "ah_private_network" "example2" {
  ip_range = "192.168.3.0/24"
  name     = "LAN for cluster2"
}

resource "ah_cloud_server" "example" {
  count        = 6
  name         = "node${count.index}"
  datacenter   = var.ah_dc
  image        = var.ah_image_type
  product      = var.ah_machine_type
  use_password = var.use_password
  ssh_keys     = ["08:be:c7:62:fb:3c:b0:1f:3d:47:46:8c:8f:57:f2:8b"]
  depends_on = [
    ah_private_network.example,
    ah_private_network.example2
  ]
}

resource "ah_private_network_connection" "example" {
  count              = 6
  cloud_server_id    = ah_cloud_server.example[count.index].id
  private_network_id = ah_private_network.example.id
  ip_address         = "192.168.2.${count.index + 10}"
  depends_on = [
    ah_cloud_server.example,
    ah_private_network.example
  ]
}

resource "ah_private_network_connection" "example2" {
  count              = 6 
  cloud_server_id    = ah_cloud_server.example[count.index].id
  private_network_id = ah_private_network.example2.id
  ip_address         = "192.168.3.${count.index + 10}"
  depends_on = [
    ah_cloud_server.example,
    ah_private_network.example,
    ah_private_network_connection.example
  ]
}