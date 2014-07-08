#!/bin/bash

set -e

function force_root {
  if [ "$(id -u)" != "0" ]; then
     echo "This script must be run as root or with sudo" 1>&2
     exit 1
  fi
}

function install_yaafe_cba_extension_dependencies {
  apt-get install -y python-numpy python-scipy unzip
}

function download_yaafe_cba_extension {
  local host="https://github.com"
  local path="mcrg-fhstp/cba-yaafe-extension/archive/master.zip"
  local temp=`mktemp /tmp/yaafe-cba-extension-XXXXX.zip`

  wget -O $temp "$host/$path"

  echo $temp
}

function install_yaafe_cba_extension {
  local tarball=$1
  local builddir=`mktemp -d /tmp/yaafe-cba-extension-build-XXXXX`

  mv $tarball $builddir
  cd $builddir
  unzip *.zip
  rm *.zip

  ls -lh
  cd cba-yaafe-extension-master
  mkdir build
  cd build
  cmake ..
  make
  make install

  rm -rf $builddir
}

###############################################################################
# RUN

download=`download_yaafe_cba_extension`

force_root

install_yaafe_cba_extension_dependencies

install_yaafe_cba_extension $download
