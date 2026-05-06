#!/bin/bash
set -e

dnf update -y
dnf install -y nginx wireguard-tools curl

systemctl enable nginx
systemctl start nginx

TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/instance-id)
INSTANCE_TYPE=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/instance-type)
AZ=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/placement/availability-zone)
PUBLIC_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/public-ipv4)

cat > /usr/share/nginx/html/index.html <<HTML
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>FIAP &mdash; AWS EC2</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { background: #0d1117; color: #c9d1d9; font-family: 'Segoe UI', monospace; display: flex; align-items: center; justify-content: center; min-height: 100vh; }
    .card { background: #161b22; border: 1px solid #30363d; border-radius: 12px; padding: 2rem 2.5rem; max-width: 480px; width: 90%; }
    .badge { display: inline-block; background: #ff9900; color: #0d1117; font-weight: 700; font-size: 0.8rem; padding: 4px 12px; border-radius: 20px; margin-bottom: 1.5rem; letter-spacing: 1px; text-transform: uppercase; }
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
    <div class="badge">Amazon Web Services</div>
    <h1>FIAP Multicloud VPN</h1>
    <table>
      <tr><td>Instance ID</td><td>${INSTANCE_ID}</td></tr>
      <tr><td>Instance Type</td><td>${INSTANCE_TYPE}</td></tr>
      <tr><td>Availability Zone</td><td>${AZ}</td></tr>
      <tr><td>Public IP</td><td>${PUBLIC_IP}</td></tr>
    </table>
    <div class="footer">Gabriel Pereira Lamata &mdash; RM562093 | FIAP Cloud Computing</div>
  </div>
</body>
</html>
HTML

systemctl restart nginx
