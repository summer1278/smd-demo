#!/bin/bash

set -e

function install_yaafe_dependencies {
  sudo apt-get install -y cmake               \
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
  sudo make install
  
  sudo chmod -R a+rw $builddir
  sudo chmod a+rx /usr/local/bin/yaafe.py

  sudo rm -rf $builddir

}

###############################################################################
# RUN

download=`download_yaafe "0.64"`

install_yaafe_dependencies

install_yaafe $download

echo "export PATH=\$PATH:/usr/local/bin" >> ~/.bash_profile
echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/usr/local/lib" >> ~/.bash_profile
echo "export PYTHONPATH=\$PYTHONPATH:/usr/local/python_packages" >> ~/.bash_profile
echo "export YAAFE_PATH=/usr/local/yaafe_extensions" >> ~/.bash_profile
chmod +x ~/.bash_profile
source ~/.bash_profile
