variable "cpus" {
  type = number
}

variable "memory" {
  type = number
}

variable "disk_size" {
  type = number
}

variable "gfx_vram_size" {
  type = number
}

variable "hard_drive_interface" {
  type = string
}

variable "hard_drive_discard" {
  type = bool
}

variable "hard_drive_nonrotational" {
  type = bool
}

variable "iso_interface" {
  type = string
}

variable "guest_os_type" {
  type = string
}

variable "vm_name" {
  type = string
}

variable "guest_additions_mode" {
  type = string
}

variable "communicator" {
  type = string
}

variable "firmware_type" {
  type = string
}

variable "export_format" {
  type = string
}

variable "iso_file" {
  type = string
}

variable "iso_url" {
  type = string
}

variable "iso_checksum" {
  type = string
}

variable "iso_source" {
  type = string
}

variable "ssh_username" {
  type = string
}

variable "ssh_password" {
  type = string
}

variable "ssh_timeout" {
  type = string
}

variable "hostname" {
  type = string
}

variable "domain" {
  type    = string
  default = ""
}

variable "http_directory" {
  type = string
}

variable "shutdown_command" {
  type = string
}

variable "boot_wait" {
  type = string
}

locals {
  formatted_datetime = formatdate("YYYY-MM-DD_hh-mm", timestamp())
  output_directory = "build/${local.formatted_datetime}"
}

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
    "<wait><wait><wait>c<wait><wait><wait>",
    "linux /install.amd/vmlinuz ",
    "auto=true ",
    "url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
    "interface=auto ",
    # "DEBCONF_DEBUG=5 ",
    "netcfg/hostname=${var.hostname} ",
    "netcfg/get_hostname=${var.hostname} ",
    "netcfg/get_domain=${var.domain} ",
    "vga=788 noprompt quiet --<enter>",
    "initrd /install.amd/initrd.gz<enter>",
    "boot<enter>"
  ]
}

build {
  sources = ["sources.virtualbox-iso.debian"]

  provisioner "shell" {
    scripts = [
      "./scripts/inst-vbox-guest-add.sh",
      "./scripts/zero_space.sh"
    ]
  }

  post-processor "vagrant" {
    compression_level    = 6
    keep_input_artifact  = true
    output               = "${local.output_directory}/${var.vm_name}.box"
  }
}