#!/bin/bash

sudo apt-get install -y vamp-plugin-sdk vamp-examples vamp-plugin-sdk-doc

# sonic annotator, urgh nice install ..
wget http://code.soundsoftware.ac.uk/attachments/download/705/sonic-annotator-1.0-linux-amd64.tar.gz
tar xvf sonic-annotator-1.0-linux-amd64.tar.gz
sudo cp sonic-annotator-1.0-linux-amd64/sonic-annotator /usr/local/bin
rm -rf sonic-annotator-1.0-linux-amd64*

# Install BBC R&D Speech / Music segmenter
wget https://github.com/bbcrd/bbc-vamp-plugins/releases/download/v1.1/Linux.64-bit.gz
sudo tar xvzf Linux.64-bit.gz -C /usr/lib/vamp
rm Linux.64-bit.gz

# Example usage
# sonic-annotator -d vamp:bbc-vamp-plugins:bbc-speechmusic-segmenter:segmentation audio/test.mp3 -w csv --csv-stdout
