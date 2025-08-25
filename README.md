### Overview
This repository provides tools for generating Packer build configurations.
Builds are available for the VirtualBox and VMware Workstation Pro hypervisors, using the corresponding builders: **virtualbox-iso** and **vmware-iso**.
A Python script combines OS-specific and hypervisor-specific YAML settings with Jinja2 templates to automate the creation of customized Vagrant boxes for virtual machines.

### Available OS Images
- Debian 12.11
- Ubuntu 24.04.3 LTS

### Usage
1. Clone the git repository.
2. Run the following commands:
```
   python -m venv .venv && source .venv/Scripts/activate
   pip install -r requirements.txt
   python main.py --${hypervisor} --${OS} (use the -h option to view more detailed information about the launch parameters)
```
3. All Packer configuration files are saved in the artifacts directory. Go to the directory of the desired hypervisor and operating system (ubuntu/ or debian/) and build the image:
```
   packer init . && packer build .
```
4. Vagrant boxes and the OVA file will be stored in the builds/${hypervisor}/${timestamp} directory.

### Tested With
- Packer: v1.13.0
- packer-plugin-vagrant: 1.1.5
- packer-plugin-virtualbox: 1.1.2
- packer-plugin-vmware: 1.1.0
- VirtualBox: 7.1.10 r169112
- VMware Workstation Pro: 17.6.2
- Vagrant: 2.4.9
- vagrant-vmware-desktop: 3.0.5

### Notes
Default login credentials:
```
login: vagrant
password: vagrant
```