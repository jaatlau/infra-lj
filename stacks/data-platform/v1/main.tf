# Providers

provider "hcloud" {
  token = var.HETZNER_TOKEN
}

# Server
module "data-platform-server" {
  source      = "./modules/server/hetzner"
  ENVIRONMENT  = var.ENVIRONMENT
  HETZNER_MAIN_SERVER_LOCATION  = var.HETZNER_MAIN_SERVER_LOCATION
  HETZNER_MAIN_SERVER_IMAGE = var.HETZNER_MAIN_SERVER_IMAGE
  HETZNER_MAIN_SERVER_TYPE = var.HETZNER_MAIN_SERVER_TYPE
  firewall_ids = [module.data-platform-firewall-rule.firewall_id]
  ssh_key_ids = [module.data-platform-ssh.ssh_key_id]
}

# Security - firewall
module "data-platform-firewall-rule" {
  source      = "./modules/security/firewall/hetzner"
  ENVIRONMENT  = var.ENVIRONMENT
  MY_IP = var.MY_IP
}

# Security - ssh
module "data-platform-ssh" {
  source      = "./modules/security/ssh/hetzner"
  HETZNER_SSH_PUBLIC_KEY  = var.HETZNER_SSH_PUBLIC_KEY
  ENVIRONMENT = var.ENVIRONMENT
}
