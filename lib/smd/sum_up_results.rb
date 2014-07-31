require 'csv'
#require 'cfa_data'

module Smd

  class SumUpResults
    def initialize( result_directory )
      @result_directory = result_directory
    end

    def sumUp
      collect_results
      combine_genre
    end

    def collect_results
      CSV.open(@result_directory+'/mp3_output.csv', 'w') do |music_csv|
        music_csv << ['Title', 'Artist', 'Type', 'Genre', 'Duration(in secs)', 'Average CFA', 'CFA correct percentage']
        Dir.glob(@result_directory+'/**/*.cfa.csv') do |cfa_csv_file|
        #file = File.open(cfa_csv_file)

        cfa_data = CfaData.new(File.open(cfa_csv_file).to_a, 2.2) #threshold = 2.2
        avg_CFA = cfa_data.avg_cfa

        header = CSV.read(cfa_csv_file.gsub('.mp3.cfa.csv', '.metadata.csv')).first
        percentage = cfa_data.cfa_percentage(header[2])

        header << avg_CFA
        header << percentage
        music_csv << header
      end
    end
  end

  def combine_genre
    results = CSV.read(@result_directory+'/mp3_output.csv',{:headers => true}) # array of arrays
    a = results.group_by {|e| e[3]}
    genres = a.keys
    #p a['Vocal'][0].field('CFA correct percentage')
    # genre, index, header
    CSV.open(@result_directory+'/avg_mp3_output.csv', 'w') do |avg_csv|
      avg_csv << ['Genre', 'AVG CFA correctness', 'Number of Tracks', 'Total duration', 'Type']
      sum_time = 0
      genres.each do |genre|
        sum = 0.0
        sum_genre_time = 0
        type = ''
        a[genre].each do |tracks|
          sum += tracks.field('CFA correct percentage').to_f
          sum_genre_time += tracks.field('Duration(in secs)').to_i
          type = tracks.field('Type')
          sum_time += tracks.field('Duration(in secs)').to_i
        end
        avg = sum/a[genre].size
        avg_csv << [genre,avg,a[genre].size, seconds_to_hours(sum_genre_time),type]
      end
      p seconds_to_days(sum_time)
    end
  end

  def seconds_to_hours( secs )
    hours = secs / 3600
    mins  = (secs % 3600) / 60
    hours.to_s + ':' + mins.to_s  
  end

  def seconds_to_days( t )
    mm, ss = t.divmod(60)            
    hh, mm = mm.divmod(60)       
    dd, hh = hh.divmod(24)
    return "%d days, %d hours, %d minutes and %d seconds" % [dd, hh, mm, ss]
  end

end
end
