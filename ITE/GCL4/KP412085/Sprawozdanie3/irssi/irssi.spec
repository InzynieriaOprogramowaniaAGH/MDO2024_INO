Name:           irssi
Version:        1.0
Release:        1%{?dist}
Summary:        Client irssi

License:        GPLv2
URL:            https://irssi.org/
Source0:        https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/tree/KP412085/ITE/GCL4/KP412085/Sprawozdanie3/irssi/releases/download/%{version}/irssi-%{version}.tar.gz


BuildRequires:  git
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
Requires:       openssl
Requires:       perl
Requires:       ncurses-libs

%description
The client of the future


%prep
%setup -n irssi -d


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



%changelog
* Tue Apr 17 2024 Kapcer Papuga <kacperpap@gmail.com> - 1.0-1
- The %{version} version and %{release} release