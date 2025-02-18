# Comprehensive Walkthrough for IPTables Commands

## Table of Contents

1. **IPTables Basics**
2. **Connection Tracking**
3. **Traffic Management Basics**
4. **Ruleset Persistence**
5. **NAT Masquerading**
6. **Port Address Translation (PAT)**
7. **Rate Limiting**
8. **Transparent HTTP Proxy**

---

## 1. IPTables Basics

### List Current Rules

```bash
sudo iptables -L
```

### Append Rules

```bash
sudo iptables -A INPUT -j ACCEPT
sudo iptables -A OUTPUT -j ACCEPT
```

### Set Default Policies

```bash
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT DROP
```

### Allow Loopback Traffic

```bash
sudo iptables -A INPUT -j ACCEPT -i lo
sudo iptables -A OUTPUT -j ACCEPT -o lo
```

### Display Rules Verbosely

```bash
sudo iptables -L -n -v --line-numbers
```

---

## 2. Connection Tracking

### Allow Established and Related Connections

```bash
sudo iptables -A INPUT -j ACCEPT -m conntrack --ctstate ESTABLISHED,RELATED
sudo iptables -A OUTPUT -j ACCEPT -m conntrack --ctstate ESTABLISHED,RELATED
```

---

## 3. Traffic Management Basics

### Delete Rules by Line Number

```bash
sudo iptables -D INPUT -1
sudo iptables -D OUTPUT -1
```

### Allow ICMP (Ping) Traffic

```bash
sudo iptables -A INPUT -j ACCEPT -p icmp --icmp-type 8
sudo iptables -A OUTPUT -j ACCEPT -p icmp --icmp-type 8
```

### Allow SSH Traffic

```bash
sudo iptables -A INPUT -j ACCEPT -p tcp --dport 22
sudo iptables -A OUTPUT -j ACCEPT -p tcp --dport 22
```

### Allow HTTP and HTTPS Traffic

```bash
sudo iptables -A OUTPUT -j ACCEPT -p tcp --dport 80
sudo iptables -A OUTPUT -j ACCEPT -p tcp --dport 443
```

### Allow DNS Queries

```bash
sudo iptables -A OUTPUT -j ACCEPT -p tcp --dport 53
sudo iptables -A OUTPUT -j ACCEPT -p udp --dport 53
```

### Allow NTP Traffic

```bash
sudo iptables -A OUTPUT -j ACCEPT -p udp --dport 123
```

---

## 4. Ruleset Persistence

### Install Persistent IPTables

```bash
sudo apt install iptables-persistent
```

### Save Current Rules

```bash
sudo sh -c "iptables-save > /etc/iptables/rules.v4"
sudo sh -c "ip6tables-save > /etc/iptables/rules.v6"
```

---

## 5. NAT Masquerading

### Enable Packet Forwarding

```bash
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
```

### Configure Masquerading for Outbound Traffic

```bash
sudo iptables -t nat -A POSTROUTING -o wan -j MASQUERADE -m comment --comment "masquerade lan->wan"
```

---

## 6. Port Address Translation (PAT)

### Configure SSH Port Forwarding

```bash
sudo iptables -t nat -A PREROUTING -p tcp --dport 22 -m comment --comment "ssh PAT->CentOS" -d 192.168.5.200 -j DNAT --to-destination 172.16.1.100
sudo iptables -A FORWARD -p tcp --dport 22 -d 172.16.1.100 -j ACCEPT -m comment --comment "ssh into CentOS"
```

---

## 7. Rate Limiting

### Limit SSH Login Attempts

```bash
sudo iptables -I INPUT 4 -p tcp --dport 22 -m conntrack --ctstate NEW -m recent --name ssh-list --set -m comment --comment "track new ssh attempts"
sudo iptables -I INPUT 5 -p tcp --dport 22 -m conntrack --ctstate NEW -m recent --name ssh-list --update --seconds 60 --hitcount 6 -j DROP -m comment --comment "drop excessive ssh attempts"
```

---

## 8. Transparent HTTP Proxy

### Redirect HTTP Traffic to Proxy Server

```bash
sudo iptables -t nat -I PREROUTING 3 -p tcp --dport 80 -m comment --comment "transparent http proxy" -s 172.16.1.0/24 -j DNAT --to-destination 172.16.1.1.1:8888
```

---

This walkthrough includes categorized examples for beginners, intermediates, and advanced users. Let me know if you'd like additional explanations or enhancements!
