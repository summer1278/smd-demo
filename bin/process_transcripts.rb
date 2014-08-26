require 'fileutils'
require 'csv'
require 'pp'
require 'fileutils'

def convert_csvs
  # remove spaces
  Dir.glob("**/*\ *").each do |original_file|
    underscore_file = original_file.gsub(" ","_")
    FileUtils.mv(original_file,underscore_file)
    p "Renamed:  #{original_file} =&gt; #{underscore_file}" 
  end
  # ssconvert file.xlsx file.csv
  Dir.glob('results/transcripts/*.xls') do |xls_file|
    system 'cd results/transcripts'
    #p  File.basename(xls_file)
    cmd = 'ssconvert '
    cmd += xls_file
    cmd += ' ' + xls_file.gsub('.xls','.csv')
    system cmd
  end
end

def download_mp3s
  FileUtils::mkdir_p '/data/speech/desert-island-discs'
  Dir.glob('/data/speech/desert-island-discs-transcripts/*.csv') do |csv_file|
    file = CSV.read(csv_file)
    #file[6][1]
    file_name = file[6][1] + '.mp3'
    if file[6][1].include?('.mp3')
      file_name = file[6][1]
    end
    if file_name.include?('dida_')
      dir = 'dida'
    else
      dir = 'did'
    end
    cmd = 'wget http://downloads.bbc.co.uk/podcasts/radio4/'+dir+'/'
    cmd += file_name+' -P ' +'/data/speech/desert-island-discs/'
    system cmd
  end
end

def compare_filenames
  count = 0
  Dir.glob('/data/speech/desert-island-discs-transcripts/*.csv') do |csv_file|
    file = CSV.read(csv_file)
    file_name = file[6][1] + '.mp3'
    if file[6][1].include?('.mp3')
      file_name = file[6][1]
    end
    if !File.exists?('/data/speech/desert-island-discs/'+file_name)
      count += 1
      p file_name
    end
  end
  p count
end

def time_to_seconds ( time )
  if dt = DateTime.parse(time) rescue false 
   dt.hour * 3600.0 + dt.min * 60.0 +dt.sec
 end
end

def generate_truth 
  #/data/speech/desert-island-discs-transcripts/
 Dir.glob('results/Lord_David_Cobbold_fc9477fb.csv') do |transcript|
  file = CSV.read(transcript)
  file_name =file[6][1] + '.truth.csv'
    if file_name.include?('.mp3')
      file_name = file_name.gsub('.mp3','')
    end
  segments = []
  segment = Array.new(3, nil)
  file.drop(14).each do |line|
    #p time_to_seconds(line[1])
    if time_to_seconds(line[1])!=nil && time_to_seconds(line[2])!=nil && time_to_seconds(line[1])<time_to_seconds(line[2])
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
      elsif line[3] == nil && line[1] != nil && line[2] !=nil
        segment[0] = time_to_seconds(line[1])
        segment[1] = time_to_seconds(line[2])
        segment[2] = 'Music'
      end
      segments << segment
      end
    end
   end
  #/data/speech/desert-island-discs/
  CSV.open('results/'+file_name, 'w') do |csv_file|
    segments.each {|row| csv_file<<row}
  end
end
end

def copy_truth
  Dir.glob('/data/results/speech/desert-island-discs/*.txt') do |txt_file|
    path = File.read(txt_file)
    #p path
    file_name = File.basename(path).gsub(".mp3\n",".truth.csv")
    #p file_name
    #new_file =File.join(txt_file.gsub('.orig.txt','.truth.csv'))
    FileUtils.cp('/data/incoming/'+file_name ,txt_file.gsub('.orig.txt','.truth.csv'))
  end
end






#convert_csvs
#download_mp3s
#compare_filenames
#generate_truth
copy_truth