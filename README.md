### Overview
This repository provides tools to generate Packer build configurations. 
A Python script combines your OS-specific YAML settings with Jinja2 templates to automate the creation of customized Vagrant boxes for virtual machines using the virtualbox-iso builder.

### Available OS Images
- [Debian 12.11](https://github.com/Serhii5465/packer-templates/tree/main/debian)
- [Ubuntu 24.04.2 LTS](https://github.com/Serhii5465/packer-templates/tree/main/ubuntu)

### Usage
1. Clone the git repository.
2. Run the following commands:
```
   python -m venv .venv && source .venv/Scripts/activate
   pip install -r requirements.txt
   python main.py --all (use the -h option to see additional parameters)
```
3. All Packer configuration files are saved in the artifacts directory. Go to the directory of the desired operating system (ubuntu/ or debian/) and build the image:
```
   packer init . && packer build --var-file=../commons.pkrvars.hcl .
```
4. Vagrant boxes and the OVA file will be stored in the builds/${timestamp} directory.

### Notes
Default login credentials:
```
login: vagrant
password: vagrant
```