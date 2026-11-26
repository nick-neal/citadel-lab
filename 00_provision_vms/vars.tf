# proxmox endpoint
variable "proxmox_endpoint" {
    default = "https://pve.citadel:8006/"
}

# for storing the API token
variable "api_token" {}

# which node the VM will go on
variable "proxmox_node_name" {
    default = "pve"
}

variable "server_2022_template_id" {
    default = 101
}

variable "dc01_mac_address" {
    default = "BC:24:11:56:B2:CB"
}
