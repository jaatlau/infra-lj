# PROJECT
variable "ENVIRONMENT" {
  description = "dev or prod"
  type        = string
}

variable "MY_IP" {
  description = "Local machine ip address which has access to via firewall rule through ssh"
  type        = string
}