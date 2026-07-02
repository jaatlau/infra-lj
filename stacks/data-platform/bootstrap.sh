#!/bin/bash
set -e

###########################################################
# Init configs

## Check for Doppler token parameter
if [ -z "$1" ]; then
    echo "❌ Usage: ./bootstrap.sh <DOPPLER_TOKEN>"
    exit 1
fi

DOPPLER_TOKEN="$1"

echo "🚀 Bootstrapping Hetzner server..."

## Update system
echo "📦 Updating system packages..."
sudo apt-get update
sudo apt-get upgrade -y


DATA_DIR="/data"


###########################################################
# Docker

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

###########################################################
# Doppler CLI

echo "🔐 Installing Doppler CLI..."
if ! command -v doppler &> /dev/null; then
    curl -sLf --retry 3 --tlsv1.2 --proto "=https" 'https://packages.doppler.com/public/cli/gpg.DE2A7741A397C129.key' | sudo gpg --dearmor -o /usr/share/keyrings/doppler-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/doppler-archive-keyring.gpg] https://packages.doppler.com/public/cli/deb/debian any-version main" | sudo tee /etc/apt/sources.list.d/doppler-cli.list
    sudo apt-get update && sudo apt-get install doppler -y
    echo "✅ Doppler CLI installed"
else
    echo "✅ Doppler CLI already installed"
fi

## Get secrets from Doppler
echo "📥 Fetching secrets from Doppler..."
TAILSCALE_AUTHKEY=$(doppler secrets get TAILSCALE_AUTHKEY --plain --token="$DOPPLER_TOKEN")
SEAWEEDFS_AWS_ACCESS_KEY_ID=$(doppler secrets get SEAWEEDFS_AWS_ACCESS_KEY_ID --plain --token="$DOPPLER_TOKEN")
SEAWEEDFS_AWS_SECRET_ACCESS_KEY=$(doppler secrets get SEAWEEDFS_AWS_SECRET_ACCESS_KEY --plain --token="$DOPPLER_TOKEN")

if [ -z "$TAILSCALE_AUTHKEY" ] || [ -z "$SEAWEEDFS_AWS_ACCESS_KEY_ID" ] || [ -z "$SEAWEEDFS_AWS_SECRET_ACCESS_KEY" ]; then
    echo "❌ Missing required secrets in Doppler: TAILSCALE_AUTHKEY, SEAWEEDFS_AWS_ACCESS_KEY_ID, SEAWEEDFS_AWS_SECRET_ACCESS_KEY"
    exit 1
fi

echo "✅ Secrets loaded from Doppler"


###########################################################
# Tailscale

echo "[1/4] Installing Tailscale..."

curl -fsSL https://tailscale.com/install.sh | sh

echo "[2/4] Enabling service..."

systemctl enable --now tailscaled

echo "[3/4] Bringing node up..."

tailscale up \
  --authkey="${TAILSCALE_AUTHKEY}" \
  --accept-routes \
  --accept-dns=false

echo "[4/4] Status"

tailscale status
tailscale ip -4

TAILSCALE_IP=$(tailscale ip -4 | head -1)

echo "Tailscale setup complete."


###########################################################
# SeaweedFS

##Configs
SEAWEEDFS_DATA_DIR="${DATA_DIR}/seaweedfs"

## install SeaweedFS
echo "🚀 Installing SeaweedFS..."

cd /tmp

wget https://github.com/seaweedfs/seaweedfs/releases/latest/download/linux_amd64.tar.gz

tar -xzf linux_amd64.tar.gz

chmod +x weed

mv weed /usr/local/bin/weed

## create user
id -u seaweedfs >/dev/null 2>&1 || \
useradd -r -s /sbin/nologin seaweedfs

## Create data dir
mkdir -p "${SEAWEEDFS_DATA_DIR}"
chown -R seaweedfs:seaweedfs "${SEAWEEDFS_DATA_DIR}"

## create env file
mkdir -p /etc/seaweedfs
cat > /etc/seaweedfs/seaweedfs.env <<EOF
S3_ACCESS_KEY=${SEAWEEDFS_AWS_ACCESS_KEY_ID}
S3_SECRET_KEY=${SEAWEEDFS_AWS_SECRET_ACCESS_KEY}
SEAWEEDFS_DATA_DIR=${SEAWEEDFS_DATA_DIR}
EOF

## create systemd service
cat > /etc/systemd/system/seaweedfs.service <<EOF
[Unit]
Description=SeaweedFS
After=network.target

[Service]
Type=simple
User=seaweedfs
Group=seaweedfs
EnvironmentFile=/etc/seaweedfs/seaweedfs.env
ExecStart=/usr/local/bin/weed server \
  -dir=\${SEAWEEDFS_DATA_DIR} \
  -s3 \
  -s3.port=8333 \
  -filer \
  -ip=${TAILSCALE_IP}
Restart=always
RestartSec=5
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

## Start service
systemctl daemon-reload
systemctl enable seaweedfs
systemctl restart seaweedfs


echo ""
echo "✅ Bootstrap complete!"
echo ""