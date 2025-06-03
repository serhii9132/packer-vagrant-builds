packer {
  required_plugins {
    virtualbox = {
      source  = "github.com/hashicorp/virtualbox"
      version = "~> 1"
    }
    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = "~> 1"
    }
  }
}

source "virtualbox-iso" "debian" {
  cpus                   = 4
  memory                 = 4096
  disk_size              = 100000
  hard_drive_interface   = "sata"
  guest_os_type          = "Debian_64"
  vm_name                = "debian-12.11"
  # headless               = true
  guest_additions_mode   = "upload"

  iso_url                = "https://cdimage.debian.org/cdimage/release/12.11.0/amd64/iso-cd/debian-12.11.0-amd64-netinst.iso"
  iso_checksum           = "file:https://cdimage.debian.org/cdimage/release/12.11.0/amd64/iso-cd/SHA256SUMS"
  iso_target_path        = "iso"

  ssh_username           = "vagrant"
  ssh_password           = "vagrant"
  ssh_timeout            = "60m"

  boot_wait              = "5s"
  shutdown_command       = "sudo shutdown -P now"

  http_directory         = "http"
  boot_command = [
    "<esc>",
    " auto preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<enter>"]
}

build {
  sources = ["sources.virtualbox-iso.debian"]

  provisioner "shell" {
    script = "./scripts/inst-vbox-guest-add.sh"
  }

  post-processor "vagrant" {
    keep_input_artifact = true
    output = "./vagrant_output/{{.BuildName}}-12.11.box"
  }
}