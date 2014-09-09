smd-demo
========
SMD-DEMO is a Ruby command-line audio feature evaluation framework for ZCR and CFA that provides results analysis from imported audio file(either MP3 or M4A). For mixed audio(i.e. Speech and Music), it also provides a web-based visualization using Peaks.js developed by BBC R&amp;D (https://github.com/bbcrd/peaks.js). This is a MSc Project in 2014 Summer, supported by UCL CS & BBC R&amp;D.

1. Import Audio
2. Collect Results
3. Visualize Results


Json File Attributes
-----------
1. startTime: endTime - time_slot #start_offset is + 25% time_slot 
2. endTime #end_offset is - 25% time_slot
3. editable: true 
4. color: waveform color
5. labelText: id of segment


Working Platform
----------
Linux or Mac OS

Dependency
-----------
Peak.js: Web-based audio visualization(https://github.com/bbcrd/peaks.js)

Taglib: Ruby binding C++ library for reading metadata from audio files(http://robinst.github.io/taglib-ruby/)

Parallel: Ruby library for parallel processing (https://github.com/grosser/parallel)

AVCONV: Fast Video and Audio Converter(http://manpages.ubuntu.com/manpages/precise/man1/avconv.1.html)

SSConvert: Converter between various spreadsheet file formats(http://manpages.ubuntu.com/manpages/karmic/man1/ssconvert.1.html)


Sinatra: Ruby domain-specific language for creating web applications(http://www.sinatrarb.com/intro.html)

Get Started
-------------
Input Audio: MP3 or M4A

