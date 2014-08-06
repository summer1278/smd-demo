require 'fileutils'
require 'csv'
require 'pp'

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
    if file_name.include?(dida)
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
    if File.exists?('/data/speech/desert-island-discs/'+file_name) == false
      p file_name
      count += 1
    end
  end
  p count
end
#convert_csvs
download_mp3s
compare_filenames