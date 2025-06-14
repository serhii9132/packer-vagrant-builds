### Known Issues
1. Hostname is ignored during preseed installation
The parameters d-i netcfg/get_hostname string <host-name>, d-i netcfg/get_domain string <domain>, and d-i netcfg/hostname <host-name>
are ignored when specified in the preseed.cfg file.

During automated installation, the installer receives the hostname from the DHCP server (via the NAT network adapter in VirtualBox) and prompts the user to enter the hostname and domain name manually.

This issue can be bypassed by explicitly passing the hostname and domain as kernel parameters in the boot command.