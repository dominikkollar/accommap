# AccomMap — Proxmox VM Infrastructure

## Architecture Decision: Ubuntu 24.04 LTS + Docker

| Option | Verdict |
|---|---|
| **Pure Ubuntu VM** (services installed directly) | Rejected — PostGIS is complex to install natively; all Docker work would be duplicated as systemd units with no benefit |
| **Ubuntu 24.04 LTS + Docker Compose** | **Selected** — reuses existing `Dockerfile`s and `docker-compose.yml` as-is; updates reduce to `git pull && docker compose up -d --build` |

Docker overhead on a VM is negligible (~50 MB RAM). The isolation, reproducibility, and reuse of the existing container definitions makes it the only sensible choice.

---

## VM Specification

| Parameter | Value | Notes |
|---|---|---|
| OS | Ubuntu 24.04 LTS (Noble) | cloud image — minimal, cloud-init ready |
| vCPUs | 2 (configurable) | 4 recommended if running scraper builds frequently |
| RAM | 4 GB | 2 GB minimum; 4 GB gives headroom for build cache |
| Disk | 50 GB | OS ~10 GB, Docker images ~5 GB, PostGIS data ~5 GB, headroom |
| Network | VirtIO on vmbr0 | add VLAN tag if needed |
| Guest agent | qemu-guest-agent | required for Terraform to read IP output |
| CPU type | `host` | change to `kvm64` if you plan live migration between unlike hosts |

---

## Stack Deployed Inside the VM

```
VM: accommap (Ubuntu 24.04)
└── Docker Compose
    ├── db         postgis/postgis:16-3.4  :5432
    ├── backend    FastAPI / uvicorn        :8000
    ├── frontend   Vite build + nginx       :3000
    └── scraper    one-shot container (cron weekly)
```

Firewall (UFW): only ports 22, 3000, 8000 inbound.

---

## Prerequisites

### 1. Create the Ubuntu 24.04 cloud-image template (once per cluster)

```bash
# SSH into any Proxmox node as root, then:
bash infra/proxmox/scripts/create-template.sh 9000 local-lvm
```

### 2. Create a Terraform API token (once per cluster)

```bash
# On the Proxmox node:
bash infra/proxmox/scripts/create-api-token.sh
# Copy the printed token secret
```

---

## Terraform Workflow

```bash
cd infra/proxmox/terraform

# 1. Configure
cp terraform.tfvars.example terraform.tfvars
$EDITOR terraform.tfvars   # fill in endpoint, token, SSH key, passwords

# 2. Init
terraform init

# 3. Plan
terraform plan

# 4. Apply
terraform apply
# Terraform prints the VM IP and app URLs after provisioning.
# cloud-init runs in the background; full setup takes ~3-5 minutes.
```

### Watching cloud-init progress

```bash
ssh ubuntu@<vm-ip>
tail -f /var/log/cloud-init-output.log
```

---

## Day-2 Operations

### Check service status

```bash
ssh ubuntu@<vm-ip>
sudo systemctl status accommap
docker compose -f /opt/accommap/docker-compose.yml ps
```

### Update the application

```bash
ssh ubuntu@<vm-ip>
cd /opt/accommap
git pull
sudo systemctl restart accommap
# or: docker compose up -d --build
```

### Run the scraper manually

```bash
ssh ubuntu@<vm-ip>
cd /opt/accommap
docker compose run --rm scraper
```

### Database backup

```bash
ssh ubuntu@<vm-ip>
docker exec accommap_db pg_dump -U accommap accommap | gzip > ~/accommap-$(date +%F).sql.gz
```

### Add TLS (Let's Encrypt via nginx reverse proxy)

Install `nginx` and `certbot` on the VM, then proxy to `localhost:3000` (frontend) and `localhost:8000` (API). Open port 443 in UFW:

```bash
sudo ufw allow 443/tcp
```

---

## File Structure

```
infra/proxmox/
├── README.md                         ← this file
├── terraform/
│   ├── main.tf                       ← VM resource (bpg/proxmox provider)
│   ├── variables.tf                  ← all configurable inputs
│   ├── outputs.tf                    ← VM ID, IP, app URLs
│   └── terraform.tfvars.example      ← copy → terraform.tfvars
├── cloud-init/
│   └── user-data.yaml.tftpl          ← Terraform template → cloud-init YAML
└── scripts/
    ├── create-template.sh            ← import Ubuntu cloud image on Proxmox node
    └── create-api-token.sh           ← create least-privilege API token
```
