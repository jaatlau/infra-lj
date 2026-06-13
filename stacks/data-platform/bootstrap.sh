#!/bin/bash
set -e

# Check for Doppler token parameter
if [ -z "$1" ]; then
    echo "❌ Usage: ./bootstrap.sh <DOPPLER_TOKEN>"
    exit 1
fi

DOPPLER_TOKEN="$1"

echo "🚀 Bootstrapping Hetzner server..."

# Update system
echo "📦 Updating system packages..."
sudo apt-get update
sudo apt-get upgrade -y

# Install Docker
echo "🐳 Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
    echo "✅ Docker installed"
else
    echo "✅ Docker already installed"
fi

# Install Doppler CLI
echo "🔐 Installing Doppler CLI..."
if ! command -v doppler &> /dev/null; then
    curl -sLf --retry 3 --tlsv1.2 --proto "=https" 'https://packages.doppler.com/public/cli/gpg.DE2A7741A397C129.key' | sudo gpg --dearmor -o /usr/share/keyrings/doppler-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/doppler-archive-keyring.gpg] https://packages.doppler.com/public/cli/deb/debian any-version main" | sudo tee /etc/apt/sources.list.d/doppler-cli.list
    sudo apt-get update && sudo apt-get install doppler -y
    echo "✅ Doppler CLI installed"
else
    echo "✅ Doppler CLI already installed"
fi


# Get secrets from Doppler
echo "📥 Fetching secrets from Doppler..."
TAILSCALE_AUTHKEY=$(doppler secrets get TAILSCALE_AUTHKEY --plain --token="$DOPPLER_TOKEN")

if [ -z "$TAILSCALE_AUTHKEY" ]; then
    echo "❌ Missing required secrets in Doppler: TAILSCALE_AUTHKEY"
    exit 1
fi

echo "✅ Secrets loaded from Doppler"


# Install Tailscale
echo "[1/4] Installing Tailscale..."

curl -fsSL https://tailscale.com/install.sh | sh

echo "[2/4] Enabling service..."

systemctl enable --now tailscaled

echo "[3/4] Bringing node up..."

tailscale up \
  --authkey="${TAILSCALE_AUTHKEY}" \
  --hostname="${TAILSCALE_HOSTNAME}" \
  --accept-routes \
  --accept-dns=false

echo "[4/4] Status"

tailscale status
tailscale ip -4

echo "Tailscale setup complete."


echo ""
echo "✅ Bootstrap complete!"
echo ""