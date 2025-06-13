locals {
  output_directory = "build/${formatdate("YYYY-MM-DD_hh-mm", timestamp())}"
  preseed_file     = "http/preseed.cfg"
}

variable "cpus" {
  type    = number
  default = 2
}

variable "memory" {
  type    = number
  default = 4096
}

variable "disk_size" {
  type    = number
  default = 50000
}

variable "gfx_vram_size" {
  type    = number
  default = 16
}

variable "hard_drive_interface" {
  type    = string
  default = "sata"
}

variable "hard_drive_discard" {
  type    = bool
  default = false
}

variable "hard_drive_nonrotational" {
  type    = bool
  default = false
}

variable "iso_interface" {
  type    = string
  default = "sata"
}

variable "guest_os_type" {
  type    = string
  default = "Debian_64"
}

variable "firmware_type" {
  type    = string
  default = "efi"
}

variable "guest_additions_mode" {
  type    = string
  default = "upload"
}

variable "iso_file" {
  type    = string
  default = "debian-12.11.0-amd64-netinst.iso"
}

variable "iso_url" {
  type    = string
  default = "https://cdimage.debian.org/cdimage/release/12.11.0/amd64/iso-cd"
}

variable "iso_checksum" {
  type    = string
  default = "file:https://cdimage.debian.org/cdimage/release/12.11.0/amd64/iso-cd/SHA256SUMS"
}

variable "iso_source" {
  type    = string
  default = "iso"
}

variable "mirror_hostname" {
  type    = string
  default = "deb.debian.org"
}

variable "export_format" {
  type    = string
  default = "ova"
}

variable "vm_name" {
  type    = string
  default = "debian-12.11"
}

variable "ssh_username" {
  type    = string
  default = "vagrant"
}

variable "ssh_password" {
  type    = string
  default = "vagrant"
}

variable "ssh_timeout" {
  type    = string
  default = "30m"
}

variable "communicator" {
  type    = string
  default = "ssh"
}

variable "hostname" {
  type    = string
  default = "debian-host"
}

variable "domain" {
  type    = string
  default = ""
}

variable "boot_wait" {
  type    = string
  default = "5s"
}

variable "shutdown_command" {
  type    = string
  default = "sudo shutdown -P now"
}