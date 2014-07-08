#!/bin/bash

set -e

function force_root {
  if [ "$(id -u)" != "0" ]; then
     echo "This script must be run as root or with sudo" 1>&2
     exit 1
  fi
}

function install_yaafe_dependencies {
  apt-get install -y cmake               \
                     cmake-curses-gui    \
                     libargtable2-0      \
                     libargtable2-dev    \
                     libsndfile1         \
                     libsndfile1-dev     \
                     libmpg123-0         \
                     libmpg123-dev       \
                     libfftw3-3          \
                     libfftw3-dev        \
                     liblapack-dev       \
                     libhdf5-serial-dev  \
                     libhdf5-serial-1.8.4

}

function download_yaafe {
  local version=$1
  local host="http://downloads.sourceforge.net"
  local path="project/yaafe/yaafe-v$version.tgz"
  local temp=`mktemp /tmp/yaafe-$version-XXXXX.tar.gz`

  wget -O $temp "$host/$path"

  echo $temp
}

function install_yaafe {
  local tarball=$1
  local builddir=`mktemp -d /tmp/yaafe-build-XXXXX`

  mv $tarball $builddir
  cd $builddir
  tar xvzf *.tar.gz
  rm *.tar.gz

  cd yaafe*

  mkdir build
  cd build
  cmake -DWITH_FFTW3=ON -DWITH_HDF5=ON -DWITH_LAPACK=ON -DWITH_MPG123=ON \
        -DWITH_SNDFILE=ON -DWITH_TIMERS=ON ..

  make 
  make install
  
  chmod -R a+rw $builddir
  chmod a+rx /usr/local/bin/yaafe.py

  rm -rf $builddir

}

###############################################################################
# RUN

download=`download_yaafe "0.64"`

force_root

install_yaafe_dependencies

install_yaafe $download

cat << EOF
Yaafe installed! Please add these lines to your ~/.bash_profile and then reload
your environment (source ~/.bash_profile)

  export PATH=\$PATH:\/usr/local/bin
  export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/usr/local/lib
  export PYTHONPATH=\$PYTHONPATH:/usr/local/python_packages
  export YAAFE_PATH=/usr/local/yaafe_extensions
EOF
