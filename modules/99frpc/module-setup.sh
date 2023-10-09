#!/usr/bin/bash

check() {
  return 0
}

depends() {
  echo network
  return 0
}

install() {
  # Register the FRPC start and stop scripts to run at appropriate times
  inst_hook initqueue 20 "$moddir/frpc-start.sh"
  inst_hook cleanup 05 "$moddir/frpc-stop.sh"

  # Make some packages available for the above scripts
  dracut_install pkill tee

  # Ensure FRPC along with a pre-defined config file (with hardcoded path) are available in initramfs
  inst "$moddir"/frpc /root/frpc
  inst "$moddir"/frpc.ini /root/frpc.ini
}