smd-demo
========
Supported by UCL CS & BBC R&amp;D, MSc Project in 2014 Summer 

1.Visualization of speech music discriminator for BBC subititle tool



Json File Attributes
-----------
1. startTime: endTime - 2.3 * gap! offest need to be fixed!
2. endTime
3. editable: false * speed-up
4. color: waveform color
5. labelText: id of segment


Use Feature Plans for YAAFE
------------
Featrue plans used in Ewald's experiments:

>yaafe.py -r 11025 --resample -f "cfa_1.15: SimpleNoiseGate>ContinuousFrequencyActivation BinThreshold=10 NbPeaks=40>WindowConvolution WCLength=17>SimpleThresholdClassification STCThreshold=1.15" -p Metadata=False audio/test.mp3

>yaafe.py -r 11025 --resample -f "cfa_1.6: SimpleNoiseGate>ContinuousFrequencyActivation BinThreshold=10 NbPeaks=40>WindowConvolution WCLength=17>SimpleThresholdClassification STCThreshold=1.6" -p Metadata=False audio/test.mp3

>yaafe.py -r 11025 --resample -f "cfa_2.2: SimpleNoiseGate>ContinuousFrequencyActivation BinThreshold=10 NbPeaks=40>WindowConvolution WCLength=17>SimpleThresholdClassification STCThreshold=2.2" -p Metadata=False audio/test.mp3
