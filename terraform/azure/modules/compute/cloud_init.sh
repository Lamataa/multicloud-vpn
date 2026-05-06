#!/bin/bash
set -e

apt-get update
apt-get install -y nginx wireguard curl jq

systemctl enable nginx
systemctl start nginx

IMDS_URL="http://169.254.169.254/metadata/instance?api-version=2021-02-01"
IMDS=$(curl -sf -H "Metadata: true" "${IMDS_URL}" || echo "{}")

VM_NAME=$(echo "${IMDS}" | jq -r '.compute.name // "unknown"')
VM_SIZE=$(echo "${IMDS}" | jq -r '.compute.vmSize // "unknown"')
LOCATION=$(echo "${IMDS}" | jq -r '.compute.location // "unknown"')
PUBLIC_IP=$(curl -sf -H "Metadata: true" \
  "http://169.254.169.254/metadata/instance/network/interface/0/ipv4/ipAddress/0/publicIpAddress?api-version=2021-02-01&format=text" \
  || echo "unknown")

cat > /var/www/html/index.html <<HTML
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>FIAP &mdash; Azure VM</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { background: #0d1117; color: #c9d1d9; font-family: 'Segoe UI', monospace; display: flex; align-items: center; justify-content: center; min-height: 100vh; }
    .card { background: #161b22; border: 1px solid #30363d; border-radius: 12px; padding: 2rem 2.5rem; max-width: 480px; width: 90%; }
    .badge { display: inline-block; background: #0078d4; color: #ffffff; font-weight: 700; font-size: 0.8rem; padding: 4px 12px; border-radius: 20px; margin-bottom: 1.5rem; letter-spacing: 1px; text-transform: uppercase; }
    h1 { font-size: 1.4rem; color: #f0f6fc; margin-bottom: 1.5rem; }
    table { width: 100%; border-collapse: collapse; }
    td { padding: 0.5rem 0; border-bottom: 1px solid #21262d; font-size: 0.9rem; }
    td:first-child { color: #8b949e; width: 50%; }
    td:last-child { color: #58a6ff; font-weight: 600; word-break: break-all; }
    tr:last-child td { border-bottom: none; }
    .footer { margin-top: 1.5rem; font-size: 0.75rem; color: #6e7681; text-align: center; }
  </style>
</head>
<body>
  <div class="card">
    <div class="badge">Microsoft Azure</div>
    <h1>FIAP Multicloud VPN</h1>
    <table>
      <tr><td>VM Name</td><td>${VM_NAME}</td></tr>
      <tr><td>VM Size</td><td>${VM_SIZE}</td></tr>
      <tr><td>Location</td><td>${LOCATION}</td></tr>
      <tr><td>Public IP</td><td>${PUBLIC_IP}</td></tr>
    </table>
    <div class="footer">Gabriel Pereira Lamata &mdash; RM562093 | FIAP Cloud Computing</div>
  </div>
</body>
</html>
HTML

systemctl restart nginx
