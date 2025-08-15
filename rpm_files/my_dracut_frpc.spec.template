%define debug_package %{nil}

Name:           my_dracut_frpc
Version:        0.0.1
Release:        1%{?dist}
Summary:        Runs FRPC in the pre-boot environment (with my hardcoded credentials)
ExclusiveArch:      x86_64

License:        None
Source0:        ./%{name}-%{version}.tar.gz

%description
Runs FRPC in the pre-boot environment (with my hardcoded credentials)

%prep
%setup -q

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/usr/lib/dracut/modules.d/99frpc
cp ./* $RPM_BUILD_ROOT/usr/lib/dracut/modules.d/99frpc
chmod +x $RPM_BUILD_ROOT/usr/lib/dracut/modules.d/99frpc/*.sh

%files
/usr/lib/dracut/modules.d/99frpc/module-setup.sh
/usr/lib/dracut/modules.d/99frpc/frpc-start.sh
/usr/lib/dracut/modules.d/99frpc/frpc-stop.sh
/usr/lib/dracut/modules.d/99frpc/frpc.ini
/usr/lib/dracut/modules.d/99frpc/frpc

%changelog
* Fri Aug 15 2025 Imran Remtulla <contact@imranr.dev>
- 
