cpus                     = 4
memory                   = 4096
disk_size                = 60000
gfx_vram_size            = 16

hard_drive_interface     = "sata"
hard_drive_discard       = false
hard_drive_nonrotational = false
iso_interface            = "sata"

firmware_type            = "efi"
export_format            = "ova"

guest_additions_mode     = "upload"
communicator             = "ssh"

timezone                 = "Europe/Kyiv"

ssh_username             = "vagrant"
ssh_password             = "vagrant"
ssh_timeout              = "30m"

iso_source               = "../iso"

boot_wait                = "5s"
shutdown_command         = "sudo shutdown -P now"