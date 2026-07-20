#!/usr/bin/sh
# Wait for network before starting frpc
while [ ! -f /tmp/net.ready ]; do
    sleep 1
done
# Start frpc in a background loop (restart on crash)
( while true; do /etc/frpc -c /etc/frpc.toml 2>&1; sleep 1; done ) &
