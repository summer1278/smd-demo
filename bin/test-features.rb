$: << 'lib'
require 'find'

require 'smd'
files = {}
found = {}

Find.find('results') do |f|
  if File.file?(f) && File.basename(f).include?('cfa.csv')
    files[f] = File.basename(f)
  end
end

files.each_value do |base|
  found[base] = 0 if !found[base]
  found[base] += 1
end

found.each do |name,count|
  if count > 1
    CSV.open('results'+'/feature_plans'+name.to_s, 'w') do |fp_csv|
      files.each do |path,filename|
        if name == filename
          #find the path of duplicate files! csv.open
          cfa_data = Smd::CfaData.new(File.open(path).to_a, 2.2) #threshold = 2.2
          avg_CFA = cfa_data.avg_cfa

          #header = CSV.read(cfa_csv_file.gsub('.mp3.cfa.csv', '.metadata.csv')).first
          percentage = cfa_data.cfa_percentage('M')#header[2])
          #header << avg_CFA
          #header << percentage
          fp_csv << [avg_CFA,percentage]
          puts "# warning duplicate #{path}"
        end
      end
    end
  end
end