### Overview
This repository contains templates for building Vagrant base boxes for VirtualBox using the virtualbox-iso builder in Packer.
Support for the vmware-iso builder is planned for future releases.

### Available OS Images
- [Debian 12.11](https://github.com/Serhii5465/packer-templates/tree/main/debian)
- [Ubuntu 24.04.2 LTS](https://github.com/Serhii5465/packer-templates/tree/main/ubuntu)


### Usage
1. Clone the git repository.
2. Go to the directory of the desired operating system (ubuntu/ or debian/)
4. Run the following command:
```
   packer init . && packer build --var-file=../commons.pkrvars.hcl .
```
5. Vagrant boxes and the OVA file will be stored in the builds/${timestamp} directory.

### Notes
Default login credentials:
```
login: vagrant
password: vagrant
```