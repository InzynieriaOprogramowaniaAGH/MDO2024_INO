Name: irssi
Version: 1
Release: 1
Summary: Project RPM package

License:        GPLv2
URL:            https://irssi.org/
Source0:        https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/tree/DP412497/ITE/GCL4/DP412497/Sprawozdanie3/irssi/releases/irssi.tar.gz

BuildRequires:  meson
BuildRequires:  gcc
BuildRequires:  glib2-devel
BuildRequires:  ncurses-devel
BuildRequires:  ninja-build
BuildRequires:  perl-ExtUtils-Embed
BuildRequires:  utf8proc-devel
BuildRequires:  cmake
BuildRequires:  openssl-devel
Requires:       glib2
Requires:       openssl-devel
Requires:       perl
Requires:       ncurses-libs


%description
RPM package maker for class.

%prep
%setup -n irssi

%build
meson Build
ninja -C %{_builddir}/irssi/Build

%install
DESTDIR=%{buildroot} ninja -C Build install
mkdir -p %{buildroot}/usr/local/share/licenses/%{name}/
cp %{_builddir}/irssi/COPYING %{buildroot}/usr/local/share/licenses/%{name}/


%files
%license /usr/local/share/licenses/%{name}/COPYING
/usr/local/bin/%{name}
/usr/local/share/%{name}/
/usr/local/share/doc 
/usr/local/share/man
/usr/local/include/
/usr/local/lib64/
/usr/local/bin/openssl

%changelog
* Tue Apr 30 2024 Daniel Per <perdaniel@student.agh.edu.pl> - 1-1
- 1 version 1 release