# Setting Up a Personal VPN Server Using OpenVPN on AWS EC2 Free Tier

## Prerequisites

- An AWS account
- Basic understanding of Linux commands
- SSH client installed on your local machine
- OpenVPN client installed on your device

## 1. Creating an EC2 Instance

1. Log in to AWS Console and navigate to EC2 Dashboard
2. Click "Launch Instance"
3. Configure the instance:
   - Name: `vpn-server`
   - AMI: Ubuntu Server 22.04 LTS (free tier eligible)
   - Instance type: t2.micro (free tier eligible)
   - Create a new key pair (download and save it securely)
   - Configure Security Group:
     ```
     Type        Protocol    Port Range    Source
     SSH         TCP         22            Your IP
     Custom UDP  UDP         1194          0.0.0.0/0
     ```
4. Launch the instance

## 2. Connecting to Your Instance

```bash
chmod 400 your-key-pair.pem
ssh -i your-key-pair.pem ubuntu@your-instance-public-ip
```

## 3. Installing OpenVPN

```bash
# Update system packages
sudo apt update
sudo apt upgrade -y

# Install OpenVPN and Easy-RSA
sudo apt install openvpn easy-rsa -y

# Create directory structure
mkdir ~/easy-rsa
ln -s /usr/share/easy-rsa/* ~/easy-rsa/
cd ~/easy-rsa
```

## 4. Setting Up Certificate Authority

```bash
# Initialize PKI
./easyrsa init-pki

# Create Certificate Authority
./easyrsa build-ca nopass

# Generate server certificate and key
./easyrsa build-server-full server nopass

# Generate Diffie-Hellman parameters
./easyrsa gen-dh
```

## 5. Configuring OpenVPN Server

```bash
# Copy required files to OpenVPN directory
sudo cp ~/easy-rsa/pki/ca.crt /etc/openvpn/
sudo cp ~/easy-rsa/pki/issued/server.crt /etc/openvpn/
sudo cp ~/easy-rsa/pki/private/server.key /etc/openvpn/
sudo cp ~/easy-rsa/pki/dh.pem /etc/openvpn/

# Create server configuration
sudo nano /etc/openvpn/server.conf
```

Add the following configuration:

```conf
port 1194
proto udp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh.pem
server 10.8.0.0 255.255.255.0
push "redirect-gateway def1"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 10 120
cipher AES-256-CBC
user nobody
group nogroup
persist-key
persist-tun
status /var/log/openvpn/openvpn-status.log
verb 3
```

## 6. Configuring System Parameters

```bash
# Enable IP forwarding
echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# Configure NAT
sudo iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
sudo apt install iptables-persistent -y
```

## 7. Starting OpenVPN Server

```bash
# Create log directory
sudo mkdir -p /var/log/openvpn

# Start OpenVPN service
sudo systemctl start openvpn@server
sudo systemctl enable openvpn@server

# Check status
sudo systemctl status openvpn@server
```

## 8. Generating Client Certificates

```bash
cd ~/easy-rsa
./easyrsa build-client-full CLIENT_NAME nopass
```

## 9. Creating Client Configuration

Create a new file `client.ovpn`:

```conf
client
dev tun
proto udp
remote YOUR_SERVER_IP 1194
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
cipher AES-256-CBC
verb 3

# Add these lines after creating them:
<ca>
# Paste contents of /etc/openvpn/ca.crt here
</ca>
<cert>
# Paste contents of ~/easy-rsa/pki/issued/CLIENT_NAME.crt here
</cert>
<key>
# Paste contents of ~/easy-rsa/pki/private/CLIENT_NAME.key here
</key>
```

## 10. Using Your VPN

1. Download the client.ovpn file to your local machine
2. Import it into your OpenVPN client
3. Connect to your VPN

## Troubleshooting

1. If connection fails:

   - Check security group settings
   - Verify server is running: `sudo systemctl status openvpn@server`
   - Check logs: `sudo tail -f /var/log/openvpn/openvpn-status.log`

2. If internet doesn't work through VPN:
   - Verify IP forwarding: `cat /proc/sys/net/ipv4/ip_forward`
   - Check iptables rules: `sudo iptables -t nat -L`

## Security Considerations

1. Always use strong certificates and keys
2. Regularly update system packages
3. Monitor server logs for suspicious activity
4. Consider implementing two-factor authentication
5. Regularly backup your certificates and keys

## Cost Considerations

- EC2 t2.micro instance is free tier eligible for 12 months
- Data transfer costs may apply:
  - First 1GB/month outbound traffic is free
  - Additional outbound traffic is charged per AWS pricing
  - Inbound traffic is free

Remember to monitor your AWS billing dashboard to track usage and costs.
