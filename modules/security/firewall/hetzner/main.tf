#ssh local dev machine + tailscale + fastapi access
resource "hcloud_firewall" "fire_wall_rules" {
  name = "${var.ENVIRONMENT}-fire-wall-rules"
  # Allow SSH only from your IP
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = [var.MY_IP]
  }

  # Allow FastAPI (8000) only from your IP
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "8000"
    source_ips = [var.MY_IP]
  }

  # Allow Tailscale
  rule {
    direction  = "in"
    protocol   = "udp"
    port       = "41641"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  # No other inbound traffic allowed
  # Ports 80, 443, 8000 → all closed

  # Outbound allowed
  rule {
    direction = "out"
    protocol = "tcp"
    destination_ips = ["0.0.0.0/0"]
  }
  rule {
    direction = "out"
    protocol = "udp"
    destination_ips = ["0.0.0.0/0"]
  }
  rule {
    direction = "out"
    protocol = "icmp"
    destination_ips = ["0.0.0.0/0"]
  }
}