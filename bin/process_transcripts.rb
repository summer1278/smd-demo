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
    #p 'processed ' + xls_file
  end
end

convert_csvs