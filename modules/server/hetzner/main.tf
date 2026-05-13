terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }
}

resource "hcloud_server" "main_server" {
  name         = "${var.ENVIRONMENT}-main-server"
  location     = var.HETZNER_MAIN_SERVER_LOCATION
  image        = var.HETZNER_MAIN_SERVER_IMAGE
  server_type  = var.HETZNER_MAIN_SERVER_TYPE
  ssh_keys     = var.ssh_key_ids
  firewall_ids = var.firewall_ids
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
}