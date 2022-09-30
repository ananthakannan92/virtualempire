#!/bin/sh

TOPDIR=${TOPDIR:-$(git rev-parse --show-toplevel)}
SRCDIR=${SRCDIR:-$TOPDIR/src}
MANDIR=${MANDIR:-$TOPDIR/doc/man}

VIRTUALEMPIRED=${VIRTUALEMPIRED:-$SRCDIR/virtualempired}
VIRTUALEMPIRECLI=${VIRTUALEMPIRECLI:-$SRCDIR/virtualempire-cli}
VIRTUALEMPIRETX=${VIRTUALEMPIRETX:-$SRCDIR/virtualempire-tx}
VIRTUALEMPIREQT=${VIRTUALEMPIREQT:-$SRCDIR/qt/virtualempire-qt}

[ ! -x $VIRTUALEMPIRED ] && echo "$VIRTUALEMPIRED not found or not executable." && exit 1

# The autodetected version git tag can screw up manpage output a little bit
VTEVER=($($VIRTUALEMPIRECLI --version | head -n1 | awk -F'[ -]' '{ print $6, $7 }'))

# Create a footer file with copyright content.
# This gets autodetected fine for virtualempired if --version-string is not set,
# but has different outcomes for virtualempire-qt and virtualempire-cli.
echo "[COPYRIGHT]" > footer.h2m
$VIRTUALEMPIRED --version | sed -n '1!p' >> footer.h2m

for cmd in $VIRTUALEMPIRED $VIRTUALEMPIRECLI $VIRTUALEMPIRETX $VIRTUALEMPIREQT; do
  cmdname="${cmd##*/}"
  help2man -N --version-string=${VTEVER[0]} --include=footer.h2m -o ${MANDIR}/${cmdname}.1 ${cmd}
  sed -i "s/\\\-${VTEVER[1]}//g" ${MANDIR}/${cmdname}.1
done

rm -f footer.h2m
