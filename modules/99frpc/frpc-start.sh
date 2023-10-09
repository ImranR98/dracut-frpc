#!/usr/bin/sh

/root/frpc -c /root/frpc.ini 2>&1 | tee /root/frpc.log &