# Setting up HTTPS on localhost:3000 with Apache2

This guide will walk you through the process of configuring HTTPS for localhost:3000 on Ubuntu/Debian using Apache2 as a reverse proxy.

## Prerequisites

- Ubuntu/Debian system
- Apache2 installed
- Root or sudo access
- OpenSSL installed
- Your application running on port 3000

## Step 1: Install Required Packages

```bash
sudo apt update
sudo apt install apache2 ssl-cert
```

## Step 2: Enable Required Apache Modules

```bash
sudo a2enmod ssl
sudo a2enmod headers
sudo a2enmod proxy
sudo a2enmod proxy_http
```

## Step 3: Generate Self-Signed SSL Certificate

```bash
sudo mkdir /etc/apache2/ssl
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/apache2/ssl/localhost.key \
    -out /etc/apache2/ssl/localhost.crt
```

When prompted, fill in the certificate information:

- Country Name: Your country code (e.g., US)
- State/Province: Your state
- Locality: Your city
- Organization Name: Your organization
- Organizational Unit: Your department
- Common Name: localhost
- Email Address: Your email

## Step 4: Configure Virtual Host for Port 3000

Create a new configuration file:

```bash
sudo nano /etc/apache2/sites-available/localhost-3000-ssl.conf
```

Add the following configuration:

```apache
<VirtualHost *:443>
    ServerName localhost

    SSLEngine on
    SSLCertificateFile /etc/apache2/ssl/localhost.crt
    SSLCertificateKeyFile /etc/apache2/ssl/localhost.key

    ProxyPreserveHost On
    ProxyPass / http://localhost:3000/
    ProxyPassReverse / http://localhost:3000/

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined

    # Optional: Add CORS headers if needed
    Header set Access-Control-Allow-Origin "*"
</VirtualHost>
```

## Step 5: Enable the Site and Redirect HTTP to HTTPS

```bash
sudo a2ensite localhost-3000-ssl
```

To redirect HTTP traffic to HTTPS, create/modify the HTTP virtual host:

```bash
sudo nano /etc/apache2/sites-available/000-default.conf
```

Add this content:

```apache
<VirtualHost *:80>
    ServerName localhost
    Redirect permanent / https://localhost/
</VirtualHost>
```

## Step 6: Test Configuration and Restart Apache

```bash
sudo apache2ctl configtest
sudo systemctl restart apache2
```

## Step 7: Update Application Configuration (if needed)

If your application needs to be aware it's being served over HTTPS:

- Set the `trust proxy` setting if using Express.js:

```javascript
app.set("trust proxy", true);
```

- Ensure any absolute URLs in your application use HTTPS

## Step 8: Trust the Self-Signed Certificate

### For Chrome/Chromium:

1. Navigate to `chrome://settings/certificates`
2. Go to the "Authorities" tab
3. Click "Import" and select your `/etc/apache2/ssl/localhost.crt` file
4. Check "Trust this certificate for identifying websites"
5. Click "OK"

### For Firefox:

1. Navigate to `https://localhost`
2. Click "Advanced"
3. Click "Accept the Risk and Continue"

## Troubleshooting

### Common Issues:

1. **Cannot Connect to Backend**
   Check if your application is running on port 3000:

```bash
sudo netstat -tulpn | grep 3000
```

2. **Apache Won't Start**

```bash
sudo journalctl -u apache2.service
sudo apache2ctl -t
```

3. **Permission Issues**

```bash
sudo chmod 600 /etc/apache2/ssl/localhost.key
sudo chmod 644 /etc/apache2/ssl/localhost.crt
```

4. **502 Bad Gateway**

- Verify your application is running
- Check Apache error logs:

```bash
sudo tail -f /var/log/apache2/error.log
```

## Security Notes

- This setup uses a self-signed certificate suitable for development only
- Never use self-signed certificates in production
- Keep your SSL key file secure and restrict its permissions
- Regularly update your system and Apache

## Additional Configuration Options

### Enable HTTP/2 (Optional)

```bash
sudo a2enmod http2
```

Add to your SSL VirtualHost configuration:

```apache
Protocols h2 http/1.1
```

### WebSocket Support (if needed)

If your application uses WebSockets, add:

```apache
ProxyPass /ws ws://localhost:3000/ws
ProxyPassReverse /ws ws://localhost:3000/ws
```
