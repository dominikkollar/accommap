#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# create-template.sh
# Run ONCE on the Proxmox node to import the Ubuntu 24.04 cloud image
# as a reusable VM template (ID 9000 by default).
#
# Usage:
#   ssh root@pve.lan
#   bash create-template.sh [TEMPLATE_ID] [STORAGE]
#
# Defaults: TEMPLATE_ID=9000, STORAGE=local-lvm
# ---------------------------------------------------------------------------
set -euo pipefail

TEMPLATE_ID="${1:-9000}"
STORAGE="${2:-local-lvm}"
IMAGE_URL="https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
IMAGE_FILE="/tmp/noble-server-cloudimg-amd64.img"

echo "==> Downloading Ubuntu 24.04 (Noble) cloud image..."
wget -q --show-progress -O "$IMAGE_FILE" "$IMAGE_URL"

echo "==> Creating base VM ${TEMPLATE_ID}..."
qm create "$TEMPLATE_ID" \
  --name ubuntu-2404-cloud \
  --memory 1024 \
  --cores 1 \
  --net0 virtio,bridge=vmbr0 \
  --serial0 socket \
  --vga serial0 \
  --agent enabled=1

echo "==> Importing disk to ${STORAGE}..."
qm importdisk "$TEMPLATE_ID" "$IMAGE_FILE" "$STORAGE"

echo "==> Attaching disk and configuring boot..."
qm set "$TEMPLATE_ID" \
  --scsihw virtio-scsi-pci \
  --scsi0 "${STORAGE}:vm-${TEMPLATE_ID}-disk-0,discard=on" \
  --ide2 "${STORAGE}:cloudinit" \
  --boot order=scsi0 \
  --citype nocloud

echo "==> Converting to template..."
qm template "$TEMPLATE_ID"

echo "==> Template ${TEMPLATE_ID} ready."
rm -f "$IMAGE_FILE"
