variable "proxmox_endpoint" {
  description = "Proxmox API endpoint, e.g. https://pve.lan:8006"
  type        = string
}

variable "proxmox_api_token" {
  description = "API token in the form user@realm!token-id=UUID"
  type        = string
  sensitive   = true
}

variable "proxmox_node" {
  description = "Proxmox node name where the VM will be created"
  type        = string
  default     = "pve"
}

variable "vm_id" {
  description = "Proxmox VM ID (must be unique in the cluster)"
  type        = number
  default     = 200
}

variable "vm_name" {
  description = "VM hostname"
  type        = string
  default     = "accommap"
}

variable "template_id" {
  description = "VM ID of the Ubuntu 24.04 cloud image template"
  type        = number
  # Create the template once with:
  #   qm create 9000 --name ubuntu-2404-cloud --memory 512 --net0 virtio,bridge=vmbr0
  #   qm importdisk 9000 noble-server-cloudimg-amd64.img local-lvm
  #   qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9000-disk-0
  #   qm set 9000 --ide2 local-lvm:cloudinit --boot c --bootdisk scsi0 --serial0 socket --vga serial0
  #   qm template 9000
}

variable "cpu_cores" {
  description = "Number of vCPU cores"
  type        = number
  default     = 2
}

variable "memory_mb" {
  description = "RAM in megabytes"
  type        = number
  default     = 4096
}

variable "disk_size" {
  description = "Root disk size (e.g. 50G)"
  type        = string
  default     = "50G"
}

variable "datastore" {
  description = "Proxmox storage pool for the VM disk"
  type        = string
  default     = "local-lvm"
}

variable "bridge" {
  description = "Network bridge"
  type        = string
  default     = "vmbr0"
}

variable "vlan_tag" {
  description = "VLAN tag (null = untagged)"
  type        = number
  default     = null
}

variable "ip_config" {
  description = "Cloud-init IP config, e.g. ip=192.168.1.50/24,gw=192.168.1.1  or  ip=dhcp"
  type        = string
  default     = "ip=dhcp"
}

variable "dns_servers" {
  description = "Space-separated DNS servers for cloud-init"
  type        = string
  default     = "1.1.1.1 8.8.8.8"
}

variable "ssh_public_key" {
  description = "SSH public key injected into the ubuntu user via cloud-init"
  type        = string
}

variable "ci_user" {
  description = "Cloud-init default user"
  type        = string
  default     = "ubuntu"
}

# ---- application config passed to provision.sh via cloud-init ----

variable "app_repo_url" {
  description = "Git URL of the accommap repository"
  type        = string
  default     = "https://github.com/dominikkollar/accommap.git"
}

variable "postgres_password" {
  description = "PostgreSQL password written to /opt/accommap/.env"
  type        = string
  sensitive   = true
}

variable "google_places_api_key" {
  description = "Google Places API key (leave empty to disable)"
  type        = string
  sensitive   = true
  default     = ""
}
