resource "hcloud_server" "main_server" {
  name         = "${var.ENVIRONMENT}-main-server"
  location     = var.HETZNER_MAIN_SERVER_LOCATION
  image        = var.HETZNER_MAIN_SERVER_IMAGE
  server_type  = var.HETZNER_MAIN_SERVER_TYPE
  ssh_keys     = [hcloud_ssh_key.server_key.id]
  firewall_ids = [hcloud_firewall.fire_wall_rules.id]
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
}