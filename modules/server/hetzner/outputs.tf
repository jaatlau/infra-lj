output "server_ip" {
  value = hcloud_server.main_server.ipv4_address
}

output "server_name" {
  value = hcloud_server.main_server.name
}