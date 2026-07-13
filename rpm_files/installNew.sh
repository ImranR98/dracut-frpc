#!/bin/bash
set -e
set

TIMESTAMP="$1"
if [ -z "$TIMESTAMP" ]; then exit 1; fi

rpm-ostree initramfs --enable --arg "--force"

if rpm-ostree status | grep -q my_dracut_frpc; then
    rpm-ostree install --apply-live --assumeyes ~/rpmbuild/RPMS/x86_64/my_dracut_frpc-0.0.$TIMESTAMP-*.rpm --uninstall my_dracut_frpc --allow-inactive --force-replacefiles || :
else
    rpm-ostree install --apply-live --assumeyes ~/rpmbuild/RPMS/x86_64/my_dracut_frpc-0.0.$TIMESTAMP-*.rpm
fi

