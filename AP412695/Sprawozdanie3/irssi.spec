Name:           irssi
Version:        Test
Release:        1%{?dist}
Summary:        Irssi Test

License:        GPLv2
URL:            https://irssi.org/
Source0:        https://github.com/InzynieriaOprogramowaniaAGH/MDO2024_INO/raw/AP412695/AP412695/Sprawozdanie3/irssi.tar.gz

BuildRequires:  cmake
BuildRequires:  gcc
BuildRequires:  meson
BuildRequires:  ninja-build
BuildRequires:  perl-ExtUtils-Embed
BuildRequires:  utf8proc-devel
BuildRequires:  openssl-devel
BuildRequires:  ncurses-devel
BuildRequires:  glib2-devel
BuildRequires:  gdb
Requires:       glib2
Requires:       openssl
Requires:       perl
Requires:       ncurses-libs       

%description
Something Something tomato


%prep
%setup -n %{name}


%build
meson Build
ninja -C Build

%install
DESTDIR=%{buildroot} ninja -C Build install
mkdir -p %{buildroot}/usr/lib/debug

%files
/usr/local/bin/%{name}
/usr/local/share/%{name}/
/usr/lib/debug/
/usr/local/include/
/usr/local/lib64/
/usr/local/share/doc
/usr/local/share/man

%changelog
* Mon Apr 29 2024 Prayge
- Initial build
