require 'csv'

def bs_percentage ( type,duration,segments )
  num_seg = ( segments.size )/3
  #p num_seg
  if 
  	num_seg == 1 
  	if segments[3] == 'Music'
  	  percentage = 1
  	else
  	  percentage = 0
  	end
  else
  	count = num_seg
  	music_duration = 0.0
  	while count > 0
  	  if segments[count*3+3] == 'Music'
        music_duration += segments[count*3+1].to_f - segments[(count-1)*3+1].to_f
        #p music_duration
      end
        count -= 1
  	end
 
	percentage = music_duration/duration.to_f
  end
  if type == 'S'
      percentage = 1 - percentage
  end
  return percentage
end

CSV.open('results'+''+'/mp3_output.csv', 'w') do |music_csv|
  Dir.glob('results'+'/**/*.cfa.csv') do |cfa_csv_file|
  	segments = CSV.read(cfa_csv_file.gsub('.cfa.csv', '.bbc-segments.csv')).flatten.compact
  	header = CSV.read(cfa_csv_file.gsub('.mp3.cfa.csv', '.metadata.csv')).first 
    duration = header[4]
    if segments != nil
      header << bs_percentage(header[2],duration,segments)
      music_csv<< header
    end
  end
end