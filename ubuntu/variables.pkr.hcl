locals {
  output_directory = "builds/${formatdate("YYYY-MM-DD_hh-mm", timestamp())}"

  http_dir = "/http"
  autoinstall_files = {
    "/meta-data" = file("${local.http_dir}/meta-data")
    "/user-data" = templatefile("${local.http_dir}/user-data.pkrtpl.hcl", { var = var })
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
  default = "Ubuntu_64"
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
  default = "ubuntu-24.04.2-live-server-amd64.iso"
}

variable "iso_url" {
  type    = string
  default = "https://releases.ubuntu.com/noble"
}

variable "iso_checksum" {
  type    = string
  default = "file:https://releases.ubuntu.com/noble/SHA256SUMS"
}

variable "export_format" {
  type    = string
}

variable "vm_name" {
  type    = string
  default = "ubuntu-24.04.2-lts"
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

variable "ssh_timeout" {
  type    = string
}

variable "communicator" {
  type    = string
}

variable "hostname" {
  type    = string
  default = "ubuntu-host"
}

variable "boot_wait" {
  type    = string
}

variable "shutdown_command" {
  type    = string
}

variable "http_directory" {
  type    = string
  default = "http"
}