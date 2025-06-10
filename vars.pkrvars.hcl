cpus                  = 4
memory                = 4096
disk_size             = 60000

hard_drive_interface      = "sata"
hard_drive_discard        = false
hard_drive_nonrotational  = false
iso_interface             = "sata"

guest_os_type         = "Debian_64"
firmware_type         = "efi"
vm_name               = "debian-12.11"
export_format         = "ova"

guest_additions_mode  = "upload"
communicator          = "ssh"

ssh_username          = "vagrant"
ssh_password          = "vagrant"
ssh_timeout           = "30m"

hostname              = "debian-host"

iso_source            = "iso"
iso_file              = "debian-12.11.0-amd64-netinst.iso"
iso_url               = "https://cdimage.debian.org/cdimage/release/12.11.0/amd64/iso-cd"
iso_checksum          = "file:https://cdimage.debian.org/cdimage/release/12.11.0/amd64/iso-cd/SHA256SUMS"

boot_wait             = "5s"
shutdown_command      = "sudo shutdown -P now"

http_directory        = "http"