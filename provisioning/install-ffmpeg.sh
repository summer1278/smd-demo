#!/bin/bash

sudo add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ precise universe multiverse"
sudo add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ precise-updates universe multiverse"
sudo apt-get update
sudo apt-get install -y ffmpeg
sudo apt-get install -y ubuntu-restricted-extras

