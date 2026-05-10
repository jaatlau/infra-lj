terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }
}

resource "hcloud_ssh_key" "server_key" {
  name       = "${var.ENVIRONMENT}-ssh-key"
  public_key = var.HETZNER_SSH_PUBLIC_KEY
}
