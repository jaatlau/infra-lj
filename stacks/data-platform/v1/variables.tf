# PROJECT
variable "ENVIRONMENT" {
  description = "dev or prod"
  type        = string
}

# PROVIDERS
variable "HETZNER_TOKEN" {
  description = "Hetzner token to setup servers"
  type        = string
}

# Security/ssh
variable "HETZNER_SSH_PUBLIC_KEY" {
  description = "ssh public key to access remote servers"
  type        = string
}

# Servers
variable "MY_IP" {
  description = "Local machine ip address which has access to via firewall rule through ssh"
  type        = string
}

variable "HETZNER_MAIN_SERVER_LOCATION" {
  description = "main server location (hetzner specific config)"
  type        = string
}

variable "HETZNER_MAIN_SERVER_IMAGE" {
  description = "main server image (hetzner specific config)"
  type        = string
}

variable "HETZNER_MAIN_SERVER_TYPE" {
  description = "main server type (hetzner specific config)"
  type        = string
}