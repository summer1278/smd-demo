require 'csv'

module Smd

  class SumUpResults
    def initialize(result_directory)
      @result_directory = result_directory
    end

    def sumUp
      CSV.open(@result_directory+'/mp3_output.csv', 'w') do |music_csv|
        music_csv << ['Title', 'Artist', 'Type', 'Genre', 'Duration(in secs)', 'Average CFA', 'CFA correct percentage']
        Dir.glob(@result_directory+'/**/*.mp3') do |mp3_file|

          cfa_file      = mp3_file+'.cfa.csv'
          metadata_file = mp3_file.gsub('.mp3', '.metadata.csv')

          if File.exists?(cfa_file) && File.exists?(metadata_file)

            file = File.open(cfa_file)
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

            header = CSV.read(metadata_file).first
            header << avg_CFA
            header << percentage
            music_csv << header
          end
        end
      end
    end
  end
end
