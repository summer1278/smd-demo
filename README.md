smd-demo
========
Supported by UCL CS & BBC R&amp;D, MSc Project in 2014 Summer 

1. Visualization of speech music discriminator
2. Gather results from a large dataset
3. Pure music/speech: correctness percentage comparison
4. Mixed music&speech: time boundary (percentage) VS ground truth


Json File Attributes
-----------
1. startTime: endTime - time_slot //start_offset is + 25% time_slot 
2. endTime // end_offset is - 25% time_slot
3. editable: true 
4. color: waveform color
5. labelText: id of segment


Use Feature Plans for YAAFE
------------
Featrue plans used in Ewald's experiments:
```
yaafe.py -r 11025 --resample -f "cfa_1.15: SimpleNoiseGate>ContinuousFrequencyActivation BinThreshold=10 NbPeaks=40>WindowConvolution WCLength=17>SimpleThresholdClassification STCThreshold=1.15" -p Metadata=False audio/test.mp3
```
```
yaafe.py -r 11025 --resample -f "cfa_1.6: SimpleNoiseGate>ContinuousFrequencyActivation BinThreshold=10 NbPeaks=40>WindowConvolution WCLength=17>SimpleThresholdClassification STCThreshold=1.6" -p Metadata=False audio/test.mp3
```
```
yaafe.py -r 11025 --resample -f "cfa_2.2: SimpleNoiseGate>ContinuousFrequencyActivation BinThreshold=10 NbPeaks=40>WindowConvolution WCLength=17>SimpleThresholdClassification STCThreshold=2.2" -p Metadata=False audio/test.mp3
```
for current example: cfa2.2 is best fit


Taglib
-----------
Ruby binding C++ library for reading metadata from audio files

Website: http://robinst.github.io/taglib-ruby/

Install C++ complier and package
```
sudo apt-get install libtag1-dev
```
```
sudo apt-get install gcc g++
```
```
sudo gem install taglib-ruby
```

BBC Segmenter
-----------
Based on Zero-Crossing Rate

Source Page: https://github.com/bbcrd/bbc-vamp-plugins/blob/master/src/SpeechMusicSegmenter.h


Peaks.js
-----------
JavaScript UI for Audio Waveform

Project Page: https://github.com/bbcrd/peaks.js
