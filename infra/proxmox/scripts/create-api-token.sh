#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# create-api-token.sh
# Run on the Proxmox node to create a least-privilege API token for Terraform.
#
# Usage:  bash create-api-token.sh
# ---------------------------------------------------------------------------
set -euo pipefail

TOKEN_USER="terraform@pam"
TOKEN_ID="accommap"
ROLE="TerraformProvisioner"

echo "==> Creating role ${ROLE} with minimal permissions..."
pveum role add "$ROLE" \
  --privs "Datastore.AllocateSpace,Datastore.Audit,Pool.Allocate,Sys.Audit,Sys.Console,Sys.Modify,VM.Allocate,VM.Audit,VM.Clone,VM.Config.CDROM,VM.Config.CPU,VM.Config.Cloudinit,VM.Config.Disk,VM.Config.HWType,VM.Config.Memory,VM.Config.Network,VM.Config.Options,VM.Migrate,VM.Monitor,VM.PowerMgmt" \
  2>/dev/null || echo "  Role already exists, skipping."

echo "==> Creating user ${TOKEN_USER}..."
pveum user add "$TOKEN_USER" --comment "Terraform service account" 2>/dev/null || true

echo "==> Assigning role to user on root path..."
pveum aclmod / --users "$TOKEN_USER" --roles "$ROLE"

echo "==> Creating API token..."
pveum user token add "$TOKEN_USER" "$TOKEN_ID" --privsep 0

echo ""
echo "==> Done. Copy the token secret above into terraform.tfvars as:"
echo "    proxmox_api_token = \"${TOKEN_USER}!${TOKEN_ID}=<secret>\""
