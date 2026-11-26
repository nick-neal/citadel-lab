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
pveum role add terraform-role -privs "VM.Allocate VM.Clone VM.Config.CDROM VM.Config.CPU VM.Config.Cloudinit VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.GuestAgent.Audit VM.Audit VM.PowerMgmt Datastore.AllocateSpace Datastore.Audit Sys.Audit"

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

## Documentation
- [Setup proxmox to use terraform](https://tcude.net/using-terraform-with-proxmox/)