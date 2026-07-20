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
  inst "$moddir"/frpc /etc/frpc
  inst "$moddir"/frpc.toml /etc/frpc.toml

  # Install TLS certificates for mTLS authentication (if present)
  mkdir -p /etc/frp
  if [ -f "$moddir"/ca.crt ]; then
    inst "$moddir"/ca.crt /etc/frp/ca.crt
  fi
  if [ -f "$moddir"/client.crt ]; then
    inst "$moddir"/client.crt /etc/frp/client.crt
  fi
  if [ -f "$moddir"/client.key ]; then
    inst "$moddir"/client.key /etc/frp/client.key
  fi
}