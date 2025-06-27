### Known Issues
1. Hostname is ignored during preseed installation
The parameters d-i netcfg/get_hostname string <host-name>, d-i netcfg/get_domain string <domain>, and d-i netcfg/hostname <host-name>
are ignored when specified in the preseed.cfg file.

During automated installation, the installer receives the hostname from the DHCP server (via the NAT network adapter in VirtualBox) and prompts the user to enter the hostname and domain name manually.

This issue can be bypassed by explicitly passing the hostname and domain as kernel parameters in the boot command.

### Notes
After deploying the image, the virtual machine can't find the EFI GRUB bootloader files.
This is the default UEFI behavior in Debian: https://wiki.debian.org/UEFI
To fix this, it is necessary to force the installation of the EFI bootloader in fallback mode:
```
d-i grub-installer/force-efi-extra-removable boolean true
```