packer {
  required_plugins {
    virtualbox = {
      source  = "github.com/hashicorp/virtualbox"
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
# guest_additions_mode   = "attach"

  iso_url                = "https://cdimage.debian.org/cdimage/release/12.11.0/amd64/iso-cd/debian-12.11.0-amd64-netinst.iso"
  iso_checksum           = "file:https://cdimage.debian.org/cdimage/release/12.11.0/amd64/iso-cd/SHA256SUMS"
  iso_target_path        = "iso"

  ssh_username           = "packer"
  ssh_password           = "packer"
  ssh_timeout            = "60m"

  boot_wait              = "5s"
  shutdown_command       = "sudo -S shutdown -P now"

  http_directory         = "http"
  boot_command = [
    "<esc>",
    " auto preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/<enter>"]
}

build {
  sources = ["sources.virtualbox-iso.debian"]
}