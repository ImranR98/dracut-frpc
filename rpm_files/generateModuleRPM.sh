#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
CURR_DIR="$(pwd)"
TEMP_DIR="$(mktemp -d)"
trap "cd \"$CURR_DIR\"; rm -rf \"$TEMP_DIR\"" EXIT

# Atomic distros have a read-only `/usr` directory so the module must be layered in as an RPM
# We do this in a toolbox since there's no need to layer in rpmdevtools for this one-time use

if [ -z "$TIMESTAMP" ]; then TIMESTAMP="$(date +%Y%m%d%H%M%S)"; fi
sed "s/0\.0\.1/0.0.$TIMESTAMP/g" "$SCRIPT_DIR"/my_dracut_frpc.spec.template > "$SCRIPT_DIR"/my_dracut_frpc.spec 

sudo dnf install rpmdevtools rpmlint -y

rm -rf ~/rpmbuild/ 2>/dev/null || :
rpmdev-setuptree

mkdir -p "$TEMP_DIR"/my_dracut_frpc-0.0.$TIMESTAMP
cp "$SCRIPT_DIR"/../modules/99frpc/* "$TEMP_DIR"/my_dracut_frpc-0.0.$TIMESTAMP
cd "$TEMP_DIR"
tar --create --file ~/rpmbuild/SOURCES/my_dracut_frpc-0.0.$TIMESTAMP.tar.gz my_dracut_frpc-0.0.$TIMESTAMP
cp "$SCRIPT_DIR"/../rpm_files/my_dracut_frpc.spec ~/rpmbuild/SPECS/

rpmlint ~/rpmbuild/SPECS/my_dracut_frpc.spec
rpmbuild -ba ~/rpmbuild/SPECS/my_dracut_frpc.spec