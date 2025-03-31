# Setting Up Multi-Factor Authentication for Root User on Debian/Ubuntu

## Overview

This document provides instructions for configuring Multi-Factor Authentication (MFA) for the root user on Debian-based systems using Google Authenticator. This setup enhances security by requiring both a password and a time-based one-time password (TOTP) for authentication.

## Prerequisites

- Debian-based Linux system (e.g., Debian, Ubuntu, Astra Linux)
- Root or sudo access
- Smartphone with an authenticator app installed (Google Authenticator, Authy, etc.)

## Implementation Steps

### 1. Install Required Packages

Install the Google Authenticator PAM module:

```bash
sudo apt update
sudo apt install libpam-google-authenticator
```

### 2. Configure Google Authenticator for Root

Run the Google Authenticator setup utility as root:

```bash
sudo su -
google-authenticator
```

Answer the configuration questions:

- "Do you want authentication tokens to be time-based?" → `y`
- Scan the displayed QR code with your authenticator app
- Note the emergency scratch codes for account recovery
- "Do you want me to update your ~/.google_authenticator file?" → `y`
- "Do you want to disallow multiple uses of the same authentication token?" → `y`
- "Do you want to do so?" (regarding the 30-second token window) → `n`
- "Do you want to enable rate-limiting?" → `y`

### 3. Configure PAM to Use Google Authenticator

Edit the PAM configuration for the `su` command:

```bash
nano /etc/pam.d/su
```

Add the following line at the top of the file:

```
auth required pam_google_authenticator.so
```

### 4. Configure SSH for MFA Authentication

Edit the SSH server configuration:

```bash
nano /etc/ssh/sshd_config
```

Ensure the following settings are configured:

```
# Enable challenge-response authentication (required for MFA)
ChallengeResponseAuthentication yes

# Enable PAM integration
UsePAM yes

# Optional: If using both key-based auth and MFA
# AuthenticationMethods publickey,keyboard-interactive
```

### 5. Test SSH Configuration

Verify the SSH configuration syntax:

```bash
/usr/sbin/sshd -t
```

If no errors are reported, restart the SSH service:

```bash
systemctl restart ssh
```

### 6. Verify MFA Setup

In a new terminal session, attempt to switch to the root user:

```bash
su -
```

You should be prompted for:

1. Your password
2. A verification code from your authenticator app

## Troubleshooting

### SSH Service Fails to Start

If the SSH service fails to start after configuration changes:

1. Check the SSH service status:

```bash
systemctl status ssh
```

2. View detailed error messages:

```bash
journalctl -xeu ssh.service
```

3. Test the SSH configuration for syntax errors:

```bash
/usr/sbin/sshd -t
```

### Authentication Methods Error

If you encounter an error about authentication methods:

1. Ensure Challenge-Response Authentication is enabled:

```
ChallengeResponseAuthentication yes
```

2. Make sure PAM is enabled:

```
UsePAM yes
```

3. If using `AuthenticationMethods`, ensure all specified methods are enabled.

### Emergency Recovery

If you're locked out of your root account:

1. Boot into recovery mode or using a live CD
2. Mount your system partition
3. Remove or comment out the Google Authenticator line from `/etc/pam.d/su`

## Security Considerations

1. **Backup**: Always keep backup codes in a secure location.
2. **Time Synchronization**: Ensure your server time is accurate as TOTP depends on synchronized time.
3. **Alternative Access**: Maintain an alternative access method in case of MFA failure.
4. **Documentation**: Update security documentation to reflect MFA requirements.

## References

- [Google Authenticator PAM module documentation](https://github.com/google/google-authenticator-libpam)
- [OpenSSH documentation](https://www.openssh.com/manual.html)
- [Debian PAM documentation](https://wiki.debian.org/PAM)
