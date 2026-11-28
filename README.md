# Citadel Lab
This is meant to be built on proxmox.

## Stages
| Name | Description |
| --- | --- |
| 00_router_init | This is what builds the router for the network. run this before any other playbook. |
| 00_default | This is base ansible deployment. This will configure the network, and other services. |

## Setup
### Add terraform user to proxmox
```bash
# create terraform role (for proxmox version 9)
pveum role add terraform-role -privs "VM.Allocate VM.Clone VM.Config.CDROM VM.Config.CPU VM.Config.Cloudinit VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.GuestAgent.Audit VM.Audit VM.PowerMgmt Datastore.AllocateSpace Datastore.Audit Sys.Audit SDN.Use"

# create terraform user and auth token
pveum user add terraform@pve
pveum aclmod / -user terraform@pve -role terraform-role
pveum user token add terraform@pve terraform-token --privsep=0

```

From a dedicated ansible host, run the following:

```bash
sudo apt update
sudo apt install -y pipx
pipx ensurepath                      # puts ~/.local/bin on your PATH; open a new shell after
pipx install --include-deps ansible  # the full package: ansible-core + the community collections
pipx install ansible-lint            # optional, but you've been using it


ansible --version                    # shows the version and which ansible.cfg it found
cd ~/ansible                         # your project folder
ansible-galaxy collection install -r requirements.yml
ansible all -m ping                  # every host should answer "pong"
```

## setup ubuntu 24.04 template
```bash
apt install -y libguestfs-tools
wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
virt-customize -a noble-server-cloudimg-amd64.img --install qemu-guest-agent --truncate /etc/machine-id
qm create 9000 --name "ubuntu-2404-cloudinit" --memory 2048 --cores 2 --net0 virtio,bridge=vmbr1,tag=10
qm importdisk 9000 noble-server-cloudimg-amd64.img local-lvm
qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9000-disk-0,discard=on 
qm set 9000 --ide2 local-lvm:cloudinit
qm set 9000 --boot c --bootdisk scsi0
qm set 9000 --serial0 socket --vga serial0
qm set 9000 --agent enabled=1
qm disk resize 9000 scsi0 20G
qm template 9000

qm set 9000 --ciuser root --sshkeys ~/.ssh/ansible_key.pub --ipconfig0 ip=dhcp --agent enabled=1
```

## change proxmox template back to VM
```bash
# change windows tepmlate
lvchange -a y pve/base-101-disk-0
lvchange -a y pve/base-101-disk-1
lvchange -a y pve/base-101-disk-2
lvchange -p rw pve/base-101-disk-0
lvchange -p rw pve/base-101-disk-1
lvchange -p rw pve/base-101-disk-2
lvrename pve/base-101-disk-0 pve/vm-101-disk-0
lvrename pve/base-101-disk-1 pve/vm-101-disk-1
lvrename pve/base-101-disk-2 pve/vm-101-disk-2

sed -i '/^template: 1$/d' /etc/pve/qemu-server/101.conf
sed -i '/^efidisk0:/s/base-101-disk/vm-101-disk/' /etc/pve/qemu-server/101.conf
sed -i '/^scsi0:/s/base-101-disk/vm-101-disk/' /etc/pve/qemu-server/101.conf
sed -i '/^tpmstate0:/s/base-101-disk/vm-101-disk/' /etc/pve/qemu-server/101.conf

```

## debug a playbook
create a yaml file defining the role and any vars:
```yaml
- name: test netplan
  hosts: localhost
  connection: local
  gather_facts: true
  vars:
    netplan_interfaces:
      ens18:  
        dhcp4: true
      ens19:
        dhcp4: false
    netplan_vlans:
      ens19.10:
        id: 10
        link: ens19
        addresses: [10.100.0.1/24]
      ens19.20:
        id: 20
        link: ens19
        addresses: [172.20.0.1/24]
  roles:
    - netplan  
```

run the role as a test:
```bash
ansible-playbook -i "localhost," test_netplan.yml --check --diff
```

## Documentation
- [Setup proxmox to use terraform](https://tcude.net/using-terraform-with-proxmox/)