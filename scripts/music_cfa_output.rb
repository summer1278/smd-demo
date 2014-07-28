require 'taglib'
require 'csv'
#ruby ./scripts/music_cfa_output.rb
feature_plan = 'yaafe.py -r 11025 --resample -f "cfa: SimpleNoiseGate>ContinuousFrequencyActivation BinThreshold=10 NbPeaks=40>WindowConvolution WCLength=17>SimpleThresholdClassification STCThreshold=2.2" -p Metadata=False '

CSV.open('music/mp3_output.csv', 'w') do |music_csv|
# header
music_csv << ['Title','Type', 'Classification','Genre','Duration(in secs)']
# for all audio files
	Dir.glob('music/*.mp3') do |mp3_file|
	#gather metadata
	title = ''
	clasf = ''
	genre = ''
	duration = ''
		TagLib::FileRef.open(mp3_file) do |fileref|
			unless fileref.null?
			tag = fileref.tag 
			title = tag.title   
			#tag.artist  
			#tag.album   
			genre = tag.genre   

			properties = fileref.audio_properties
			duration = properties.length  
			end
		end 
   
    # generate cfa output
	system(feature_plan+mp3_file)
	# sum-up classification result
	file = File.open(mp3_file+'.cfa.csv')
	lines = file.to_a.map(&:to_i)
	if lines.include?(0)
		clasf = 'S'
		if lines.include?(1)
			clasf = clasf + '&M'
		end
	end
	if lines.include?(1) && !lines.include?(0) 
		clasf = 'M'
	end
	# add this entry
	music_csv << [title,'M', clasf, genre, duration]
	end
end
