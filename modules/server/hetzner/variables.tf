# PROJECT
variable "ENVIRONMENT" {
  description = "dev or prod"
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

variable "firewall_ids" {
  type=list(string)
}

variable "ssh_key_ids" {
  type = list(string)
}