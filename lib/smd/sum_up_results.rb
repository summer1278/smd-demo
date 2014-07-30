require 'csv'

module Smd

class SumUpResults
  def initialize(result_directory) 
    @result_directory = result_directory
  end
  
  def sumUp
    CSV.open(@result_directory+'/mp3_output.csv', 'w') do |music_csv|
      music_csv << ['Title', 'Artist', 'Type', 'Genre', 'Duration(in secs)', 'Average CFA', 'CFA correct percentage']
      Dir.glob(@result_directory+'/**/*.cfa.csv') do |mp3_file|
  	    file = File.open(mp3_file)
        lines = file.to_a#.map(&:to_i)
        avg_CFA = lines.reduce(0.0){ |sum, el| sum + el.to_f }.to_f / lines.size

        classified = lines.map do |i| 
          if i.to_f >= 2.2
            1
          else
            0
          end
        end
        
        ones = classified.select { |i| i == 1 }.size
        percentage = ones.to_f/classified.size.to_f
	    
	    header = CSV.read(mp3_file.gsub('.mp3.cfa.csv', '.metadata.csv')).first
	    header << avg_CFA
	    header << percentage
	    music_csv << header
	  end
    end
  end
  end
end
