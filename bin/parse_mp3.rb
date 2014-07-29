require 'taglib'
require 'csv'

feature_plan = 'yaafe.py -r 11025 --resample -f "cfa: SimpleNoiseGate>ContinuousFrequencyActivation BinThreshold=10 NbPeaks=40>WindowConvolution WCLength=17>SimpleThresholdClassification STCThreshold=2.2" -p Metadata=False '
audio_cmd = 'audiowaveform -i '#test.mp3 -o test.dat
audio_setting = ' -z 256 -b 8'

# NOTE: may need rename some audio files as a pre-process for cmd applications
# File.rename()

# for all audio files
Dir.glob('music/*.mp3') do |mp3_file|
  # gather metadata
  TagLib::FileRef.open(mp3_file) do |fileref|
    unless fileref.null?
      tag = fileref.tag 
      #title = tag.title   
      #tag.artist  
      #tag.album   
      #genre = tag.genre   

      properties = fileref.audio_properties
      #duration = properties.length  
      CSV.open(mp3_file+'.metadata.csv', 'w') do |music_csv|
	    music_csv << [tag.title,'M', tag.genre, properties.length]
      end
    end
  end
  # generate cfa output
  system(feature_plan+mp3_file)
  file = File.open(mp3_file+'.cfa.csv')
  lines = file.to_a.map(&:to_i)
  lines.each_with_object(Hash.new(0)) { |number,counts| counts[number] += 1 }
  #classification = 0.0
  #classification = counts[1]/(counts[0]+counts[1])
  
  # generate audiowaveform for Peaks.js
  system(audio_cmd+mp3_file+' -o '+mp3_file+'.dat '+audio_setting)
end
