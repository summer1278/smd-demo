require 'csv'
r#equire 'pp'
require 'date'

def time_to_seconds ( time )
  if dt = DateTime.parse(time) rescue false 
     dt.hour * 3600 + dt.min * 60 +dt.sec
  end
end

Dir.glob('results/transcript-csv/*.csv') do |transcript|
  file_name = File.basename(transcript).gsub('.csv', '.truth.csv')
  file = CSV.read(transcript)
  segments = []
  segment = Array.new(3, nil)
  file.drop(14).each do |line|
    if segments.last && segments.last[1] == time_to_seconds(line[1]) && segments.last[2] == 'Music' &&
      line[3] == nil
      segments.last[1] = time_to_seconds(line[2])
    elsif segments.last && segments.last[1] == time_to_seconds(line[1]) && segments.last[2] == 'Speech' &&
      line[3] != nil
      segments.last[1] = time_to_seconds(line[2])
    else
      segment = Array.new(3, nil)
      if line[0] == 'Music' || line[0] == 'Opening Credits' || 
        line[0] == 'Closing Credits' || line[3] != nil
        segment[0] = time_to_seconds(line[1])
        segment[1] = time_to_seconds(line[2])
        
        if line[0] == 'Music' || line[0] == 'Opening Credits' || 
          line[0] == 'Closing Credits'
          segment[2] = 'Music'
        elsif line[3] != nil
          segment[2] = 'Speech'
        end
      elsif line[3] == nil
        segment[0] = time_to_seconds(line[1])
        segment[1] = time_to_seconds(line[2])
        segment[2] = 'Music'
      end
      segments << segment
    end

    end
    pp segments
    CSV.open('results/'+file_name, 'w') do |csv_file|
      segments.each {|row| csv_file<<row}
    end
end

