VENV = .venv
PIP = $(VENV)/Scripts/pip
PYTHON = $(VENV)/Scripts/python
ARTIFACTS_DIR = artifacts
ENV_FILE = .env

init:
	python -m venv $(VENV)
	$(PIP) install -r requirements.txt
	$(PYTHON) -m pip install --upgrade pip

ubuntu-vbox-rootless: $(PYTHON) $(ENV_FILE)
	$(PYTHON) main.py --virtualbox --ubuntu --rootless
	packer init $(ARTIFACTS_DIR)/virtualbox/ubuntu/ubuntu.pkr.hcl
	packer build $(ARTIFACTS_DIR)/virtualbox/ubuntu/ubuntu.pkr.hcl

ubuntu-vbox: $(PYTHON) $(ENV_FILE)
	$(PYTHON) main.py --virtualbox --ubuntu
	packer init $(ARTIFACTS_DIR)/virtualbox/ubuntu/ubuntu.pkr.hcl
	packer build $(ARTIFACTS_DIR)/virtualbox/ubuntu/ubuntu.pkr.hcl

debian-vbox-rootless: $(PYTHON) $(ENV_FILE)
	$(PYTHON) main.py --virtualbox --debian --rootless
	packer init $(ARTIFACTS_DIR)/virtualbox/debian/debian.pkr.hcl
	packer build $(ARTIFACTS_DIR)/virtualbox/debian/debian.pkr.hcl

debian-vbox: $(PYTHON) $(ENV_FILE)
	$(PYTHON) main.py --virtualbox --debian
	packer init $(ARTIFACTS_DIR)/virtualbox/debian/debian.pkr.hcl
	packer build $(ARTIFACTS_DIR)/virtualbox/debian/debian.pkr.hcl

ubuntu-vmware-rootless: $(PYTHON) $(ENV_FILE)
	$(PYTHON) main.py --vmware --ubuntu --rootless
	packer init $(ARTIFACTS_DIR)/vmware/ubuntu/ubuntu.pkr.hcl
	packer build $(ARTIFACTS_DIR)/vmware/ubuntu/ubuntu.pkr.hcl

ubuntu-vmware: $(PYTHON) $(ENV_FILE)
	$(PYTHON) main.py --vmware --ubuntu
	packer init $(ARTIFACTS_DIR)/vmware/ubuntu/ubuntu.pkr.hcl
	packer build $(ARTIFACTS_DIR)/vmware/ubuntu/ubuntu.pkr.hcl

debian-vmware-rootless: $(PYTHON) $(ENV_FILE)
	$(PYTHON) main.py --vmware --debian --rootless
	packer init $(ARTIFACTS_DIR)/vmware/debian/debian.pkr.hcl
	packer build $(ARTIFACTS_DIR)/vmware/debian/debian.pkr.hcl

debian-vmware: $(PYTHON) $(ENV_FILE)
	$(PYTHON) main.py --vmware --debian
	packer init $(ARTIFACTS_DIR)/vmware/debian/debian.pkr.hcl
	packer build $(ARTIFACTS_DIR)/vmware/debian/debian.pkr.hcl

clean: $(VENV)
	rm -rf $(VENV)

clean_artifacts: $(ARTIFACTS_DIR)
	rm -rf $(ARTIFACTS_DIR)