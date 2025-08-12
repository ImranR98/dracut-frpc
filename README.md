# dracut-frpc

Run an [FRP](https://github.com/fatedier/frp) client during system boot using [Dracut](https://en.wikipedia.org/wiki/Dracut_(software)).

Meant for use with [dracut-crypt-ssh](https://github.com/dracut-crypt-ssh/dracut-crypt-ssh) to remotely decrypt a Fedora server that is behind [NAT](https://en.wikipedia.org/wiki/Network_address_translation).

Also supports [secureblue](https://secureblue.dev/).

## Usage

1. Prerequisites:
   - Ensure a network connection is available in the pre-boot environment.
     - For a wired connection on systems that use GRUB, this is as simple as adding `rd.neednet=1 ip=dhcp` to the `GRUB_CMDLINE_LINUX` variable in `/etc/default/grub`, then running `grub2-mkconfig --output /etc/grub2.cfg`.
   - Ensure whatever services you'll use FRP for (for example, an SSH service via `dracut-crypt-ssh`), are also already setup to run in the initramfs environment.
2. Run `setup.sh`. This will:
   1. Download the latest version of FRPC.
   2. Grab a user-defined FRPC config file.
   3. Install the Dracut module.

## See Also

- https://fedoramagazine.org/initramfs-dracut-and-the-dracut-emergency-shell/
- https://fedoraproject.org/wiki/How_to_debug_Dracut_problems#Identifying_your_problem_area\
- https://github.com/dracutdevs/dracut/blob/master/man/dracut.cmdline.7.asc