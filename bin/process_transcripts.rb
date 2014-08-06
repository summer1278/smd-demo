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
  system 'cd new'
  Dir.glob('/data/speech/desert-island-discs-transcripts/*.csv') do |csv_file|
    file = CSV.read(csv_file)
    #file[6][1]
    cmd = 'wget http://downloads.bbc.co.uk/podcasts/radio4/dida/'
    cmd += file[6][1]+ '.mp3 -P ' +'/data/speech/desert-island-discs/'
    system cmd
  end
end

#convert_csvs
download_mp3s