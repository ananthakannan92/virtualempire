VERSION=1.0.2.0
rm -rf ./release-linux
mkdir release-linux

cp ./src/virtualempired ./release-linux/
cp ./src/virtualempire-cli ./release-linux/
cp ./src/qt/virtualempire-qt ./release-linux/
cp ./VIRTUALEMPIRECOIN_small.png ./release-linux/

cd ./release-linux/
strip virtualempired
strip virtualempire-cli
strip virtualempire-qt

#==========================================================
# prepare for packaging deb file.

mkdir virtualempirecoin-$VERSION
cd virtualempirecoin-$VERSION
mkdir -p DEBIAN
echo 'Package: virtualempirecoin
Version: '$VERSION'
Section: base 
Priority: optional 
Architecture: all 
Depends:
Maintainer: Virtualempire
Description: Virtualempire coin wallet and service.
' > ./DEBIAN/control
mkdir -p ./usr/local/bin/
cp ../virtualempired ./usr/local/bin/
cp ../virtualempire-cli ./usr/local/bin/
cp ../virtualempire-qt ./usr/local/bin/

# prepare for desktop shortcut
mkdir -p ./usr/share/icons/
cp ../VIRTUALEMPIRECOIN_small.png ./usr/share/icons/
mkdir -p ./usr/share/applications/
echo '
#!/usr/bin/env xdg-open

[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Exec=/usr/local/bin/virtualempire-qt
Name=virtualempirecoin
Comment= virtualempire coin wallet
Icon=/usr/share/icons/VIRTUALEMPIRECOIN_small.png
' > ./usr/share/applications/virtualempirecoin.desktop

cd ../
# build deb file.
dpkg-deb --build virtualempirecoin-$VERSION

#==========================================================
# build rpm package
rm -rf ~/rpmbuild/
mkdir -p ~/rpmbuild/{RPMS,SRPMS,BUILD,SOURCES,SPECS,tmp}

cat <<EOF >~/.rpmmacros
%_topdir   %(echo $HOME)/rpmbuild
%_tmppath  %{_topdir}/tmp
EOF

#prepare for build rpm package.
rm -rf virtualempirecoin-$VERSION
mkdir virtualempirecoin-$VERSION
cd virtualempirecoin-$VERSION

mkdir -p ./usr/bin/
cp ../virtualempired ./usr/bin/
cp ../virtualempire-cli ./usr/bin/
cp ../virtualempire-qt ./usr/bin/

# prepare for desktop shortcut
mkdir -p ./usr/share/icons/
cp ../VIRTUALEMPIRECOIN_small.png ./usr/share/icons/
mkdir -p ./usr/share/applications/
echo '
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Exec=/usr/bin/virtualempire-qt
Name=virtualempirecoin
Comment= virtualempire coin wallet
Icon=/usr/share/icons/VIRTUALEMPIRECOIN_small.png
' > ./usr/share/applications/virtualempirecoin.desktop
cd ../

# make tar ball to source folder.
tar -zcvf virtualempirecoin-$VERSION.tar.gz ./virtualempirecoin-$VERSION
cp virtualempirecoin-$VERSION.tar.gz ~/rpmbuild/SOURCES/

# build rpm package.
cd ~/rpmbuild

cat <<EOF > SPECS/virtualempirecoin.spec
# Don't try fancy stuff like debuginfo, which is useless on binary-only
# packages. Don't strip binary too
# Be sure buildpolicy set to do nothing

Summary: Virtualempire wallet rpm package
Name: virtualempirecoin
Version: $VERSION
Release: 1
License: MIT
SOURCE0 : %{name}-%{version}.tar.gz
URL: https://www.virtualempirecoin.net/

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root

%description
%{summary}

%prep
%setup -q

%build
# Empty section.

%install
rm -rf %{buildroot}
mkdir -p  %{buildroot}

# in builddir
cp -a * %{buildroot}


%clean
rm -rf %{buildroot}


%files
/usr/share/applications/virtualempirecoin.desktop
/usr/share/icons/VIRTUALEMPIRECOIN_small.png
%defattr(-,root,root,-)
%{_bindir}/*

%changelog
* Tue Aug 24 2021  Virtualempire Project Team.
- First Build

EOF

rpmbuild -ba SPECS/virtualempirecoin.spec



