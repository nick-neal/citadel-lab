# proxmox endpoint
variable "proxmox_endpoint" {
    default = "https://192.168.0.183:8006/"
}

# for storing the API token
variable "api_token" {
    type = string
    sensitive = true
}

# which node the VM will go on
variable "proxmox_node_name" {
    default = "pve"
}

variable "server_2022_template_id" {
    default = 101
}

variable "ubuntu_2404_template_id" {
    default = 9000
}

# ====================
# GW01
# ====================

variable "gw01_mac_address" {
    default = "BC:24:11:72:D4:99"
}

# ====================
# DC01
# ====================

variable "dc01_mac_address" {
    default = "BC:24:11:56:B2:CB"
}
