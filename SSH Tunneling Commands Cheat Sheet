# 🛡️ SSH Tunneling Commands Cheat Sheet

| Type | Command | Purpose | Example |
|:----|:--------|:--------|:--------|
| **Local Port Forwarding** | `ssh -L [local_port]:[remote_host]:[remote_port] [user]@[ssh_server]` | Access remote service **from your machine** | `ssh -L 8080:localhost:8000 abhishek@192.168.0.104` |
| **Remote Port Forwarding** | `ssh -R [remote_port]:[local_host]:[local_port] [user]@[ssh_server]` | Expose your **local service** on a remote server | `ssh -R 8000:localhost:3000 abhishek@192.168.0.104` |
| **Dynamic Port Forwarding (SOCKS Proxy)** | `ssh -D [local_port] [user]@[ssh_server]` | Route all your internet traffic through SSH (like a VPN) | `ssh -D 1080 abhishek@192.168.0.104` |

---

# 🛠️ Detailed Examples

## 1. **Local Port Forwarding (you ➔ remote)**

Forward your machine's port ➔ to a remote service.

```bash
ssh -L 8080:localhost:8000 abhishek@192.168.0.104
```
- You visit `localhost:8080`
- You are actually seeing `192.168.0.104:8000`

**Use case:** Access a database or website on the remote server that is firewalled.

---

## 2. **Remote Port Forwarding (remote ➔ you)**

Expose your local port onto the remote machine.

```bash
ssh -R 8000:localhost:3000 abhishek@192.168.0.104
```
- Someone on **192.168.0.104:8000** can access **your computer's localhost:3000**.

**Use case:** Expose your development server temporarily to someone on the internet.

---

## 3. **Dynamic Port Forwarding (SOCKS Proxy)**

Create a SOCKS proxy server via SSH.

```bash
ssh -D 1080 abhishek@192.168.0.104
```
- Configure your browser to use SOCKS5 proxy `localhost:1080`.
- Your internet traffic routes securely through the SSH server.

**Use case:** Bypass firewalls, browse securely, like a poor man’s VPN.

---

# 🌟 Bonus: Useful Variations

## Forward multiple ports at once:

```bash
ssh -L 8080:localhost:8000 -L 9090:localhost:9000 abhishek@192.168.0.104
```
(Forward **two services** in one command.)

---

## Remote bind on all interfaces (public access):

```bash
ssh -R 0.0.0.0:8000:localhost:3000 abhishek@192.168.0.104
```
(Requires `GatewayPorts yes` in `/etc/ssh/sshd_config`.)

---

## Tunnel without opening a remote shell:

```bash
ssh -N -L 8080:localhost:8000 abhishek@192.168.0.104
```
- `-N` = no command execution.
- Useful for tunnels only.

---

## Background SSH tunnel:

```bash
ssh -f -N -L 8080:localhost:8000 abhishek@192.168.0.104
```
- `-f` = run in background after authentication.
- `-N` = no remote command.

Great for automation and cronjobs!

---

# 🚀 Quick Summary Table

| Option | Meaning |
|:-------|:--------|
| `-L` | Local forwarding (you ➔ remote) |
| `-R` | Remote forwarding (remote ➔ you) |
| `-D` | Dynamic forwarding (SOCKS proxy) |
| `-N` | No remote command execution |
| `-f` | Run SSH in background |
| `-E` | Preserve environment variables (for `sudo`) |
| `-i` | Specify private key |
| `-v`, `-vvv` | Verbose output (for debugging) |

---

# 📜 Bonus: Permanent SSH Tunnel in ~/.ssh/config

```bash
Host mytunnel
  HostName 192.168.0.104
  User abhishek
  LocalForward 8080 localhost:8000
```

Then simply run:

```bash
ssh mytunnel
```

---

# 📱 Pro Tip

Combine SSH tunnels with **autossh** to keep them alive forever even if the network drops!


