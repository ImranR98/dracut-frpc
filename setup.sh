#!/bin/bash

set -e

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Download the latest version of FRPC and add it to the module
FRPVER="$(curl -s https://api.github.com/repos/fatedier/frp/releases/latest | grep -oE 'tag/.*' | grep -oE '[0-9]+(\.[0-9]+)*')"
if [ -z "$FRPVER" ]; then
    info "Could not scrape frp version." >&2
    exit 1
fi
RELNAME=frp_"$FRPVER"_linux_amd64
wget https://github.com/fatedier/frp/releases/download/v"$FRPVER"/"$RELNAME".tar.gz
tar -xvf "$RELNAME".tar.gz
rm "$RELNAME".tar.gz
mv "$RELNAME"/frpc "$HERE"/modules/99frpc/frpc
rm -r "$RELNAME"
chmod +x "$HERE"/modules/99frpc/frpc

# Ask the user for an FRPC config file and add it to the module
FRPC_INI="$1"
while [ -z "$FRPC_INI" ]; do
    echo "Enter the location of frpc.ini: "
    read FRPC_INI
done
cp "$FRPC_INI" "$HERE"/modules/99frpc/frpc.ini

# Add the module to dracut
MODULE_DIR=/usr/lib/dracut/modules.d/99frpc
if [ -d "$MODULE_DIR" ]; then sudo rm -r "$MODULE_DIR"; fi
sudo mkdir -p "$MODULE_DIR"
sudo cp "$HERE"/modules/99frpc/* "$MODULE_DIR"
sudo chmod +x "$MODULE_DIR"/*.sh

# Build the module
echo "About to build the module. Press Enter to continue."
read anything
sudo dracut -f -v

# Conclusion
echo "Use 'lsinitrd | less' and 'lsinitrd -f <file>' to explore the built image."