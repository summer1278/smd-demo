#!/bin/bash

# RUBY FOR SCRIPTING AND WEB STUFF
sudo apt-get install -y build-essential       \
                        irb1.9.1              \
                        libopenssl-ruby1.9.1  \
                        libreadline-dev       \
                        libssl-dev            \
                        libtag1-dev           \
                        libxml2               \
                        libxml2-dev           \
                        libxslt-dev           \
                        rdoc1.9.1             \
                        ri1.9.1               \
                        ruby1.9.1             \
                        ruby1.9.1-dev         \
                        rubygems1.9.1         \
                        zlib1g-dev

sudo update-alternatives                               \
  --install /usr/bin/ruby ruby /usr/bin/ruby1.9.1 400  \
  --slave   /usr/share/man/man1/ruby.1.gz ruby.1.gz    \
            /usr/share/man/man1/ruby1.9.1.1.gz         \
  --slave   /usr/bin/ri ri /usr/bin/ri1.9.1            \
  --slave   /usr/bin/irb irb /usr/bin/irb1.9.1         \
  --slave   /usr/bin/rdoc rdoc /usr/bin/rdoc1.9.1;     \
  echo 2 | sudo update-alternatives --config ruby;     \
  echo 2 | sudo update-alternatives --config gem

sudo gem install bundler json rack taglib-ruby thin
