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

source "virtualbox-iso" "ubuntu" {
  cpus                   = var.cpus
  memory                 = var.memory
  disk_size              = var.disk_size
  gfx_vram_size          = var.gfx_vram_size
  vboxmanage = [
    [ "modifyvm", "{{.Name}}", "--audio", "none" ],
    [ "modifyvm", "{{.Name}}", "--vrde", "off" ],
  ]

  hard_drive_interface     = var.hard_drive_interface
  hard_drive_discard       = var.hard_drive_discard
  hard_drive_nonrotational = var.hard_drive_nonrotational
  iso_interface            = var.iso_interface

  guest_os_type          = var.guest_os_type
  firmware               = var.firmware_type
  vm_name                = var.vm_name

  guest_additions_mode   = var.guest_additions_mode
  format                 = var.export_format

  communicator           = var.communicator
  ssh_username           = var.ssh_username
  ssh_password           = var.ssh_password
  ssh_timeout            = var.ssh_timeout

  iso_url                = "${var.iso_url}/${var.iso_file}"
  iso_checksum           = var.iso_checksum
  iso_target_path        = "${var.iso_source}/${var.iso_file}"
  output_directory       = local.output_directory
  http_directory         = var.http_directory

  boot_wait              = var.boot_wait
  shutdown_command       = var.shutdown_command

  boot_command = [
    "e<wait>",
    "<down><down><down>",
    "<end><bs><bs><bs><bs><wait>",
    "ipv6.disable=1 \"ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/\" autoinstall ---<wait>",
    "<f10><wait>"
  ]
}


build {
  sources = ["sources.virtualbox-iso.ubuntu"]

  provisioner "shell" {
    scripts = [
      "../scripts/inst-vbox-guest-add.sh",
      "../scripts/zero_space.sh"
    ]
  }

  post-processor "vagrant" {
    compression_level    = 6
    keep_input_artifact  = true
    output               = "${local.output_directory}/${var.vm_name}.box"
  }
}