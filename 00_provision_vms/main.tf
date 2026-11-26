terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.123.1"
    }
  }
}

provider "proxmox" {
    endpoint = vars.proxmox_endpoint
    api_token = vars.api_token
    insecure = true
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
        source_vm_id = vars.server_2022_template_id
    }

    network = {
        net0 = {
            bridge = "vmbr1"
            model = "virtio"
            tag = 10
            mac_address = vars.dc01_mac_address
        }
    }
}