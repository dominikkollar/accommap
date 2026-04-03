terraform {
  required_version = ">= 1.6"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.66"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = true # set false when using a valid TLS cert on Proxmox
}

# ---------------------------------------------------------------------------
# Cloud-init user-data rendered from template file
# ---------------------------------------------------------------------------
locals {
  user_data = templatefile("${path.module}/../cloud-init/user-data.yaml.tftpl", {
    ssh_public_key        = var.ssh_public_key
    ci_user               = var.ci_user
    app_repo_url          = var.app_repo_url
    postgres_password     = var.postgres_password
    google_places_api_key = var.google_places_api_key
  })
}

# Upload cloud-init user-data as a snippet so Proxmox can attach it
resource "proxmox_virtual_environment_file" "cloud_init_user_data" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.proxmox_node

  source_raw {
    data      = local.user_data
    file_name = "accommap-user-data.yaml"
  }
}

# ---------------------------------------------------------------------------
# Virtual Machine
# ---------------------------------------------------------------------------
resource "proxmox_virtual_environment_vm" "accommap" {
  name      = var.vm_name
  node_name = var.proxmox_node
  vm_id     = var.vm_id

  description = "AccomMap — Ubuntu 24.04 + Docker Compose stack"
  tags        = ["accommap", "docker", "ubuntu"]

  agent {
    enabled = true # requires qemu-guest-agent installed via cloud-init
  }

  cpu {
    cores = var.cpu_cores
    type  = "host" # exposes host CPU features; use "kvm64" for migration
  }

  memory {
    dedicated = var.memory_mb
    floating  = var.memory_mb # enable memory ballooning up to dedicated
  }

  # Boot from cloned template disk
  clone {
    vm_id = var.template_id
    full  = true
  }

  disk {
    datastore_id = var.datastore
    interface    = "scsi0"
    size         = var.disk_size
    discard      = "on"
    iothread     = true
    file_format  = "raw"
  }

  network_device {
    bridge   = var.bridge
    model    = "virtio"
    vlan_id  = var.vlan_tag
    firewall = false
  }

  # Cloud-init drive
  initialization {
    datastore_id = var.datastore

    ip_config {
      ipv4 {
        address = var.ip_config == "ip=dhcp" ? "dhcp" : split(",", replace(var.ip_config, "ip=", ""))[0]
        gateway = var.ip_config == "ip=dhcp" ? null : split("gw=", var.ip_config)[1]
      }
    }

    dns {
      servers = split(" ", var.dns_servers)
    }

    user_data_file_id = proxmox_virtual_environment_file.cloud_init_user_data.id
  }

  # Wait for guest agent to confirm the VM is up
  started = true
  timeout_start_vm = 300
}
