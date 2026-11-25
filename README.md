# Citadel Lab
This is meant to be built on proxmox.

## Stages
| Name | Description |
| --- | --- |
| 00_router_init | This is what builds the router for the network. run this before any other playbook. |
| 00_default | This is base ansible deployment. This will configure the network, and other services. |

## Setup
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