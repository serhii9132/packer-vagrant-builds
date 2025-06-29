locals {
  output_directory = "builds/${formatdate("YYYY-MM-DD_hh-mm", timestamp())}"

  preseed_filename = "preseed.cfg"
  http_dir = "/http"
  preseed_file = {
    "/${local.preseed_filename}" = templatefile("${local.http_dir}/preseed.pkrtpl.hcl", { var = var })
  }
}

variable "cpus" {
  type    = number
}

variable "memory" {
  type    = number
}

variable "disk_size" {
  type    = number
}

variable "gfx_vram_size" {
  type    = number
}

variable "hard_drive_interface" {
  type    = string
}

variable "hard_drive_discard" {
  type    = bool
}

variable "hard_drive_nonrotational" {
  type    = bool
}

variable "iso_interface" {
  type    = string
}

variable "guest_os_type" {
  type    = string
  default = "Debian_64"
}

variable "firmware_type" {
  type    = string
}

variable "guest_additions_mode" {
  type    = string
}

variable "iso_source" {
  type    = string
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

variable "mirror_hostname" {
  type    = string
  default = "deb.debian.org"
}

variable "export_format" {
  type    = string
}

variable "vm_name" {
  type    = string
  default = "debian-12"
}

variable "timezone" {
  type    = string
}

variable "ssh_username" {
  type    = string
}

variable "ssh_password" {
  type    = string
}

variable "ssh_pub_key" {
    type = string
}

variable "ssh_timeout" {
  type    = string
}

variable "communicator" {
  type    = string
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
}

variable "shutdown_command" {
  type    = string
}