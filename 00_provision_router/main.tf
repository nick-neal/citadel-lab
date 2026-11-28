terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.123.1"
    }
  }
}

provider "proxmox" {
    endpoint = var.proxmox_endpoint
    api_token = var.api_token
    insecure = true

    ssh {
        agent = true
        username = "root"
    }
}

resource "proxmox_cloned_vm" "gw01" {
  node_name = var.proxmox_node_name
  name      = "gw01"

  clone = {
    source_vm_id = var.ubuntu_2404_template_id
    full         = true
  }

  cpu = {
    sockets = 1
    cores   = 1
  }

  memory = {
    size = 2048
  }

  disk = {
    scsi0 = {
      datastore_id = "local-lvm"
      size_gb      = 32
      discard      = "on"
    }
  }

  network = {
    net0 = {
      bridge      = "vmbr0"
      model       = "virtio"
      mac_address = var.gw01_mac_address
    }
    net1 = {
      bridge = "vmbr1"
      model  = "virtio"
    }
  }
}