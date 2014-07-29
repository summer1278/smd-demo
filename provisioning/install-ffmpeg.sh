#!/bin/bash

sudo add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ precise universe multiverse"
sudo add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ precise-updates universe multiverse"
sudo apt-get update
sudo apt-get install -y ffmpeg
sudo DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' -f -q -y install ubuntu-restricted-extras
