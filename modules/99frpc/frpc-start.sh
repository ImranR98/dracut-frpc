#!/usr/bin/sh

while true; do
  /etc/frpc -c /etc/frpc.toml 2>&1 && break
done &
