#!/usr/bin/sh

/etc/frpc -c /etc/frpc.ini 2>&1 | tee /etc/frpc.log &