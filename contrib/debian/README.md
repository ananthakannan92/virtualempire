
Debian
====================
This directory contains files used to package virtualempired/virtualempire-qt
for Debian-based Linux systems. If you compile virtualempired/virtualempire-qt yourself, there are some useful files here.

## virtualempire: URI support ##


virtualempire-qt.desktop  (Gnome / Open Desktop)
To install:

	sudo desktop-file-install virtualempire-qt.desktop
	sudo update-desktop-database

If you build yourself, you will either need to modify the paths in
the .desktop file or copy or symlink your virtualempire-qt binary to `/usr/bin`
and the `../../share/pixmaps/virtualempire128.png` to `/usr/share/pixmaps`

virtualempire-qt.protocol (KDE)

