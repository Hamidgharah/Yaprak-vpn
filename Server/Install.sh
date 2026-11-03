#!/bin/bash
# Yaprak-VPN Automatic Server Setup Script (VLESS + Reality)

echo "=== Updating System Packages ==="
sudo apt update && sudo apt upgrade -y

echo "=== Installing Xray-core ==="
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install

echo "=== Generating Keys ==="
KEYS=$(xray x25519)
PRIVATE_KEY=$(echo "$KEYS" | grep "Private key:" | awk '{print $3}')
PUBLIC_KEY=$(echo "$KEYS" | grep "Public key:" | awk '{print $3}')
UUID=$(xray uuid)

cat <<EOF > /usr/local/etc/xray/config.json
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "port": 443,
      "protocol": "vless",
      "settings": {
        "clients": [{ "id": "$UUID", "flow": "xtls-rprx-vision" }],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "tcp",
        "security": "reality",
        "realitySettings": {
          "show": false,
          "dest": "www.google.com:443",
          "xver": 0,
          "serverNames": ["www.google.com"],
          "privateKey": "$PRIVATE_KEY",
          "shortIds": [""]
        }
      }
    }
  ],
  "outbounds": [{ "protocol": "freedom" }]
}
EOF

echo "=== Restarting Xray Service ==="
systemctl restart xray
systemctl enable xray

echo "=================================================="
echo "Yaprak-VPN Installed Successfully!"
echo "UUID: $UUID"
echo "Public Key: $PUBLIC_KEY"
echo "=================================================="
