# PROJECT
variable "ENVIRONMENT" {
  description = "dev or prod"
  type        = string
}

variable "HETZNER_SSH_PUBLIC_KEY" {
  description = "ssh public key to access remote servers"
  type        = string
}