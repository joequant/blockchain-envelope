#!/bin/bash
# These are all of the packages that need to be installed before bootstrap
# is run
set -e -v

source /tmp/proxy.sh

curl https://dl.google.com/go/go1.13.5.linux-amd64.tar.gz | tar -C /usr/local -xzf -

pushd /usr/local/bin
ln -s ../go/bin/go .
popd
go help

urpmi.removemedia -a
urpmi.addmedia --distrib --mirrorlist http://mirrors.mageia.org/api/mageia.7.x86_64.list
urpmi.addmedia kernel http://mirror.tuxinator.org/mageia/distrib/7/x86_64/media/core/updates
urpmi.update -a
urpmi --auto-update
urpmi --no-recommends --excludedocs --auto \
    git \
    libgit2-devel \
    gcc-c++ \
    make \
    nodejs \
    python3-docutils \
    python3-pip \
    sudo \
    openssl-devel \
    gnupg2 \
    cargo \
    pam-devel


