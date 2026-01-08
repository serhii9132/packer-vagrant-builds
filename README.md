### Overview
This repository provides tools for generating Packer build configurations.
Builds are available for the VirtualBox and VMware Workstation Pro hypervisors.
A Python script combines OS-specific and hypervisor-specific YAML settings with Jinja2 templates to automate the creation of customized Vagrant boxes for virtual machines. Supports creating an image that contains only a root account and a user with passwordless sudo privileges. For more details, see the **Options** section.

### Supported Packer builders:
- [virtualbox-iso](https://developer.hashicorp.com/packer/integrations/hashicorp/virtualbox/latest/components/builder/iso)
- [vmware-iso](https://developer.hashicorp.com/packer/integrations/hashicorp/vmware/latest/components/builder/iso#configuration-reference)

### Available OS Images
- Debian 13.2
- Ubuntu 24.04.3 LTS

### Attention
These scripts are used exclusively for image creation and deployment for local development.

### Options
```sh
$ python main.py -h

usage: main.py [-h] (--virtualbox | --vmware) (--all | --ubuntu | --debian) [--rootless]

options:
  -h, --help    show this help message and exit
  --virtualbox  Generate configuration for VirtualBox.
  --vmware      Generate configuration for VMware Workstation.
  --all         Generate configurations for all supported OSes (Ubuntu and Debian).
  --ubuntu      Generate configuration only for Ubuntu.
  --debian      Generate configuration only for Debian.
  --rootless    Generate a rootless image configuration (for testing without root access).
```

### Usage
1. Clone the git repository.
2. Create a .env file in the root of the project with the following content:
```sh
SUDO_USER=user
PASSWORD="$6$dYP4Mapass1234..."                 # Use: mkpasswd -m sha-512
PRIVATE_KEY_FILE="C://.ssh//keys//key.pem"
PUBLIC_KEY="ssh-ed25519 AAAABBBBCCCC1234..." 
```
3. Run the following commands:
```
   python -m venv .venv && source .venv/Scripts/activate
   pip install -r requirements.txt
   python main.py --${hypervisor} --${OS} (use the -h option to view more detailed information about the launch parameters)
```
4. All Packer configuration files are saved in the artifacts directory. Go to the directory of the desired hypervisor and operating system (ubuntu/ or debian/) and build the image:
```
   packer init . && packer build .
```
5. Vagrant boxes and the OVA file will be stored in the builds/${timestamp} directory.

### Tested With
- Packer: v1.14.3
- packer-plugin-vagrant: 1.1.6
- packer-plugin-virtualbox: 1.1.3
- packer-plugin-vmware: 1.2.0
- VirtualBox: 7.2.4
- VMware Workstation Pro: 25H2
- Vagrant: 2.4.9
- vagrant-vmware-desktop: 3.0.5