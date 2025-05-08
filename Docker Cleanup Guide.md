# 🐳 Docker Cleanup Guide

This guide provides a list of Docker commands to clean up **unused credentials, data, and content**.

---

## 🔥 1. Remove Unused Docker Objects (All-in-One)

```bash
docker system prune
```

Removes:

- Stopped containers
- Unused networks
- Dangling images
- Build cache

**With all unused images:**

```bash
docker system prune -a
```

**Force without confirmation:**

```bash
docker system prune -a -f
```

---

## 🧱 2. Remove Dangling (Unused) Images Only

```bash
docker image prune
```

**Remove all unused images:**

```bash
docker image prune -a
```

---

## 📦 3. Remove Unused Volumes

```bash
docker volume prune
```

---

## 🌐 4. Remove Unused Networks

```bash
docker network prune
```

---

## 📂 5. Remove Build Cache

```bash
docker builder prune
```

**All cache layers:**

```bash
docker builder prune --all
```

---

## 🧼 6. Remove All Stopped Containers

```bash
docker container prune
```

---

## 🧾 7. Remove Docker Credentials (Manually)

Docker credentials are stored in:

- `~/.docker/config.json`

To clear stored credentials:

```bash
cat ~/.docker/config.json
```

Then manually edit or reset:

```bash
> ~/.docker/config.json
```

---

## 🧹 8. Optional: Clear Everything (Cautious Approach)

```bash
docker container stop $(docker ps -aq)
docker container rm $(docker ps -aq)
docker image rm $(docker images -q)
docker volume rm $(docker volume ls -q)
docker network rm $(docker network ls -q | grep -v "bridge\|host\|none")
```

This fully wipes all containers, images, volumes, and custom networks.

---

**Use these commands with caution, especially in production environments.**
