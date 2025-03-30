# UFW (Uncomplicated Firewall) Complete Cheatsheet

## Basic Commands

### Installation
```bash
sudo apt update
sudo apt install ufw
```

### Status Commands
```bash
sudo ufw status                    # Check current status
sudo ufw status verbose            # Detailed status
sudo ufw status numbered           # Show rules with numbers
```

### Enable/Disable
```bash
sudo ufw enable                    # Enable and start on boot
sudo ufw disable                   # Disable firewall
sudo ufw reload                    # Reload rules
```

### Default Policies
```bash
sudo ufw default deny incoming     # Block all incoming by default
sudo ufw default allow outgoing    # Allow all outgoing by default
sudo ufw default reject incoming   # Reject all incoming with ICMP response
sudo ufw default deny outgoing     # Block all outgoing
```

## Managing Rules

### Basic Allow/Deny
```bash
sudo ufw allow ssh                 # Allow SSH (port 22)
sudo ufw deny http                 # Deny HTTP (port 80)
sudo ufw reject https              # Reject HTTPS with ICMP response
```

### Working with Port Numbers
```bash
sudo ufw allow 22                  # Allow port 22 (SSH)
sudo ufw allow 80/tcp              # Allow TCP on port 80
sudo ufw allow 53/udp              # Allow UDP on port 53
sudo ufw deny 3306                 # Deny port 3306 (MySQL)
```

### Port Ranges
```bash
sudo ufw allow 3000:3100/tcp       # Allow TCP ports 3000-3100
sudo ufw allow 60000:61000/udp     # Allow UDP port range
```

### IP Addresses
```bash
sudo ufw allow from 192.168.1.100           # Allow all from IP
sudo ufw deny from 10.0.0.5                 # Deny all from IP
sudo ufw allow from 192.168.0.0/24          # Allow from subnet
sudo ufw deny from 10.0.0.0/8 to any port 25 # Block subnet to port 25
```

### Specific Interfaces
```bash
sudo ufw allow in on eth0 to any port 80    # Allow HTTP on eth0
sudo ufw deny in on eth1                    # Deny all on eth1
```

### Combining IP and Ports
```bash
sudo ufw allow from 192.168.1.100 to any port 22              # Allow SSH from specific IP
sudo ufw allow from 10.0.0.0/8 to any port 80                 # Allow HTTP from subnet
sudo ufw deny from 10.0.0.5 to any port 22                    # Block SSH from IP
sudo ufw allow from 192.168.0.0/24 to any port 3306 proto tcp # Allow MySQL from subnet
```

### Delete Rules
```bash
sudo ufw delete allow 80           # Delete "allow 80" rule
sudo ufw delete deny 22            # Delete "deny 22" rule
sudo ufw delete 3                  # Delete rule number 3 (use status numbered first)
```

## Advanced Usage

### Application Profiles
```bash
sudo ufw app list                  # List available profiles
sudo ufw allow "Nginx Full"        # Allow profile
sudo ufw deny "OpenSSH"            # Deny profile
```

### Logging
```bash
sudo ufw logging on                # Enable logging
sudo ufw logging off               # Disable logging
sudo ufw logging low|medium|high   # Set logging level
```

### Rate Limiting
```bash
sudo ufw limit ssh                 # Limit SSH connections (max 6 in 30 seconds)
sudo ufw limit 22/tcp              # Same as above
```

### IPv6 Support
```bash
# Edit /etc/default/ufw and set:
IPV6=yes
# Then reload
sudo ufw reload
```

### Reset to Default
```bash
sudo ufw reset                     # Reset to default settings
```

## Custom Rules

### Custom Service
```bash
# Add service to /etc/services
myservice    12345/tcp

# Then use it
sudo ufw allow myservice
```

### Custom Rules File
```bash
# Add custom rule to /etc/ufw/before.rules or /etc/ufw/after.rules

# Example: Port Forwarding
*nat
:PREROUTING ACCEPT [0:0]
-A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080
COMMIT
```

## Practical Examples

### Web Server
```bash
sudo ufw allow 80/tcp              # HTTP
sudo ufw allow 443/tcp             # HTTPS
```

### Mail Server
```bash
sudo ufw allow 25/tcp              # SMTP
sudo ufw allow 143/tcp             # IMAP
sudo ufw allow 587/tcp             # Submission
sudo ufw allow 993/tcp             # IMAPS
```

### Database Server
```bash
sudo ufw allow from 192.168.1.0/24 to any port 3306   # MySQL from internal network
sudo ufw allow from 192.168.1.0/24 to any port 5432   # PostgreSQL from internal network
```

### Home Router
```bash
sudo ufw allow ssh                 # SSH
sudo ufw allow from 192.168.1.0/24 # Allow all from LAN
sudo ufw default deny incoming     # Block everything else
```

## Checking Logs

```bash
sudo tail -f /var/log/ufw.log      # View UFW logs
```

## Troubleshooting

### Common Issues
1. Rules not taking effect: `sudo ufw reload`
2. Locked out of SSH: Boot into recovery and disable ufw
3. Application not working: Check for blocked ports with `sudo ufw status`

### Best Practices
1. Always allow SSH before enabling UFW
2. Use specific rules rather than broad ones
3. Test rules before implementing in production
4. Document your firewall configuration
5. Periodically audit your rules
