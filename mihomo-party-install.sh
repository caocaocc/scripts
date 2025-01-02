#!/bin/bash
set -e -o pipefail

ARCH_RAW=$(uname -m)
case "${ARCH_RAW}" in
    'x86_64')    ARCH='amd64';;
    'x86' | 'i686' | 'i386')     ARCH='386';;
    'aarch64' | 'arm64') ARCH='arm64';;
    'armv7l')   ARCH='armv7';;
    's390x')    ARCH='s390x';;
    *)          echo "Unsupported architecture: ${ARCH_RAW}"; exit 1;;
esac

VERSION=$(curl -s https://api.github.com/repos/mihomo-party-org/mihomo-party/releases/latest \
    | grep tag_name \
    | cut -d ":" -f2 \
    | sed 's/\"//g;s/\,//g;s/\ //g;s/v//')

if command -v dpkg >/dev/null 2>&1; then
    PKG_TYPE="deb"
    INSTALL_CMD="sudo dpkg -i"
elif command -v rpm >/dev/null 2>&1; then
    PKG_TYPE="rpm"
    INSTALL_CMD="sudo rpm -i"
else
    echo "Neither dpkg nor rpm found. Exiting."
    exit 1
fi

curl -Lo "mihomo-party.${PKG_TYPE}" "https://github.com/mihomo-party-org/mihomo-party/releases/download/v${VERSION}/mihomo-party-linux-${VERSION}-${ARCH}.${PKG_TYPE}"
$INSTALL_CMD "mihomo-party.${PKG_TYPE}"
rm "mihomo-party.${PKG_TYPE}"
