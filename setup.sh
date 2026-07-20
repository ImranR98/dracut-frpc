#!/bin/bash

set -e

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

SUDO_COMMAND="sudo"
if which rpm-ostree; then SUDO_COMMAND="run0"; fi # Support secureblue

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

# Parse CLI arguments
CERT_FILE=""
KEY_FILE=""
CA_FILE=""
FRPC_INI=""
while [ $# -gt 0 ]; do
    case "$1" in
        --cert) CERT_FILE="$2"; shift 2 ;;
        --key)  KEY_FILE="$2"; shift 2 ;;
        --ca)   CA_FILE="$2"; shift 2 ;;
        *)      FRPC_INI="$1"; shift ;;
    esac
done

# Ask the user for an FRPC config file and add it to the module
while [ -z "$FRPC_INI" ]; do
    echo "Enter the location of frpc.toml: "
    read FRPC_INI
done
cp "$FRPC_INI" "$HERE"/modules/99frpc/frpc.toml

# Copy TLS certificates into the module (for mTLS auth)
if [ -n "$CA_FILE" ]; then
    cp "$CA_FILE" "$HERE"/modules/99frpc/ca.crt
fi
if [ -n "$CERT_FILE" ]; then
    cp "$CERT_FILE" "$HERE"/modules/99frpc/client.crt
fi
if [ -n "$KEY_FILE" ]; then
    cp "$KEY_FILE" "$HERE"/modules/99frpc/client.key
fi

if ! which rpm-ostree 2>&1 >/dev/null; then
    # Add the module to dracut
    MODULE_DIR=/usr/lib/dracut/modules.d/99frpc
    if [ -d "$MODULE_DIR" ]; then $SUDO_COMMAND rm -r "$MODULE_DIR"; fi
    $SUDO_COMMAND mkdir -p "$MODULE_DIR"
    $SUDO_COMMAND cp "$HERE"/modules/99frpc/* "$MODULE_DIR"
    $SUDO_COMMAND chmod +x "$MODULE_DIR"/*.sh

    # Build the module
    echo "About to build the module. Press Enter to continue."
    read anything
    $SUDO_COMMAND dracut -f -v
else
    export TIMESTAMP="$(date +%Y%m%d%H%M%S)"
    if [ "$RUN_TOOLBOX_STEPS_WITH_ASSUMPTIONS" == true ]; then
        toolbox run "$HERE"/rpm_files/generateModuleRPM.sh "$TIMESTAMP"
        ./rpm_files/installNew.sh $TIMESTAMP
    else
        read -p "You are on an rpm-ostree based distro, so installation cannot complete without some manual steps. 
Please do the following:
1. Create a Fedora container using toolbox.
2. Run 'rpm_files/generateModuleRPM.sh $TIMESTAMP' in the container.
3. Run './rpm_files/installNew.sh $TIMESTAMP'

Press Enter to continue." ANYTHING
        exit
    fi

fi

# Conclusion
echo "Use 'lsinitrd | less' and 'lsinitrd -f <file>' to explore the built image."
