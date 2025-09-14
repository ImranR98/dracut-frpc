#!/usr/bin/sh

/etc/frpc -c /etc/frpc.toml 2>&1 | tee /etc/frpc.log &