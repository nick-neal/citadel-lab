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

resource "proxmox_cloned_vm" "dc01" {
    node_name = var.proxmox_node_name
    name      = "dc01"

    cpu = {
        sockets = 1
        cores = 2
    }

    memory = {
        size = 4096
    }

    clone = {
        source_vm_id = var.server_2022_template_id
        full = true
    }

    network = {
        net0 = {
            bridge = "vmbr1"
            model = "virtio"
            tag = 10
            mac_address = var.dc01_mac_address
        }
    }
}

resource "proxmox_cloned_vm" "db01" {
    node_name = var.proxmox_node_name
    name      = "db01"

    cpu = {
        sockets = 1
        cores = 2
    }

    memory = {
        size = 4096
    }

    clone = {
        source_vm_id = var.server_2022_template_id
        full = true
    }

    network = {
        net0 = {
            bridge = "vmbr1"
            model = "virtio"
            tag = 10
            mac_address = var.db01_mac_address
        }
    }
}

resource "proxmox_cloned_vm" "elk" {
  node_name = var.proxmox_node_name
  name      = "elk"

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
      size_gb      = 60
      discard      = "on"
    }
  }

  network = {
    net0 = {
      bridge      = "vmbr1"
      model       = "virtio"
      tag         = 10
      mac_address = var.elk_mac_address
    }
  }
}