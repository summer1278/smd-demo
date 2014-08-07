require 'csv'
require 'pp'

Dir.glob('results/transcript-csv/Andrew_neil_958ea1d1.csv') do |transcript|
  file_name = File.basename(transcript).gsub('.csv', '.truth.csv')
  #p file_name
  
  file = CSV.read(transcript)
  segments = []
  segment = Array.new(3, nil)
  file.drop(15).each do |line|
    if segments.last && segments.last[1] == line[1] && segments.last[2] == 'Music' &&
      line[3] == nil
      segments.last[1] = line[2]
    elsif segments.last && segments.last[1] == line[1] && segments.last[2] == 'Speech' &&
      line[3] != nil
      segments.last[1] = line[2]
    else
      segment = Array.new(3, nil)
      if line[0] == 'Music' || line[0] == 'Opening Credits' || 
        line[0] == 'Closing Credits' || line[3] != nil
        #segment = Array.new(3, nil)
        segment[0] = line[1]
        segment[1] = line[2]
        
        if line[0] == 'Music' || line[0] == 'Opening Credits' || 
          line[0] == 'Closing Credits'
          segment[2] = 'Music'
        elsif line[3] != nil
          segment[2] = 'Speech'
        end
      elsif line[3] == nil
        segment[0] = line[1]
        segment[1] = line[2]
        segment[2] = 'Music'
      end
      segments << segment
    end
      #p segment
      #csv_file << segment
      
    end
    pp segments
    CSV.open('results/'+file_name+'.csv', 'w') do |csv_file|
      segments.each {|row| csv_file<<row}
    end
end

