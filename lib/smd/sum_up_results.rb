require 'csv'
require 'parallel'
module Smd

  class SumUpResults
    def initialize( result_directory, window_size, threshold )
      @result_directory = result_directory
      @window_size = window_size.to_f
      @threshold = threshold.to_f
    end

    def sumUp
      collect_results
      combine_genre
      #combine_threshold_results
    end

    def collect_results
      list = []
       # Dir.glob(@result_directory+'/**/*.cfa.csv') do |cfa_csv_file|
       cfa_csv_files = Dir.glob(@result_directory+'/**/*.cfa.csv')
       Parallel.map(cfa_csv_files, :in_threads => 4 ) do |cfa_csv_file|
        header = CSV.read(cfa_csv_file.gsub('.mp3.cfa.csv', '.metadata.csv')).first
        cfa_data = CfaData.new(File.open(cfa_csv_file).to_a, @threshold, @window_size, @window_size/2.0) #threshold = 2.2
        zcr_data = ZcrData.new(CSV.read(cfa_csv_file.gsub('.cfa.csv', '.bbc-segments.csv')).flatten.compact)
        if header[2] != 'MIXED'
          cfa_percentage = cfa_data.cfa_percentage(header[2])
          zcr_percentage = zcr_data.zcr_percentage(header[2],header[4])
          header << cfa_percentage
          header << zcr_percentage   
        else
          cfa_time = cfa_data.cfa_time       
          cfa_mixed_data = MixedAudio.new(CSV.read(cfa_csv_file.gsub('.mp3.cfa.csv','.truth.csv')),
            cfa_time, header[4])
          cfa_percentage = cfa_mixed_data.boundary_correctness
          cfa_ds = cfa_mixed_data.boundary_search
          cfa_count = cfa_mixed_data.songs_count
          zcr_time = zcr_data.zcr_time(header[4].to_f)
          zcr_mixed_data = MixedAudio.new(CSV.read(cfa_csv_file.gsub('.mp3.cfa.csv','.truth.csv')),
            zcr_time, header[4])
          zcr_percentage = zcr_mixed_data.boundary_correctness
          zcr_ds = zcr_mixed_data.boundary_search   
          zcr_count = zcr_mixed_data.songs_count
          header = (header << [cfa_percentage, zcr_percentage, cfa_ds, zcr_ds, cfa_count,zcr_count]).flatten
        end
        list << header
        sleep 0
      end
      #p list
    CSV.open(@result_directory+'/mp3_output.csv', 'w') do |music_csv|
        music_csv << ['Title', 'Artist', 'Type', 'Genre', 'Duration(in secs)',
          'CFA correct percentage', 'ZCR correct percentage', 
          'CFA missing boundary', 'CFA wrongly inserted boundary',
          'CFA AVG boundary distance','ZCR missing boundary', 
          'ZCR wrongly inserted boundary',
          'ZCR AVG boundary distance','CFA songs count','ZCR songs count']
        list.each{|row| music_csv<<row}
    end
  end

  def combine_genre
    results = CSV.read(@result_directory+'/mp3_output.csv',{:headers => true}) # array of arrays
    a = results.group_by {|e| e[3]}
    genres = a.keys
    dir = @result_directory+@threshold.to_s
    FileUtils.mkdir_p dir
    CSV.open(dir+'/avg_mp3_output.csv', 'w') do |avg_csv|
      avg_csv << ['Genre', 'AVG CFA correctness', 'AVG ZCR correctness',
        'AVG CFA missing','AVG CFA wrongly','AVG CFA distance',
        'AVG ZCR missing','AVG ZCR wrongly','AVG ZCR distance',
        'AVG CFA songs count', 'AVG ZCR songs count',
        'Number of Tracks', 'Total duration', 'Type']
      sum_time = 0
      genres.each do |genre|
        sum = 0.0
        sum_zcr = 0.0
        sum_genre_time = 0
        sum_cfa_mis = 0.0 
        sum_cfa_wg = 0.0
        sum_cfa_ds = 0.0
        sum_zcr_mis = 0.0
        sum_zcr_wg = 0.0
        sum_zcr_ds = 0.0
        sum_cfa_sc = 0.0
        sum_zcr_sc = 0.0
        type = ''
        a[genre].each do |tracks|
          if tracks.field('CFA correct percentage') != nil && tracks.field('ZCR correct percentage')!=nil
            type = tracks.field('Type')
            sum += tracks.field('CFA correct percentage').to_f
            sum_zcr += tracks.field('ZCR correct percentage').to_f
            if type == 'MIXED'
              sum_cfa_mis += tracks.field('CFA missing boundary').to_f
              sum_cfa_wg += tracks.field('CFA wrongly inserted boundary').to_f
              sum_cfa_ds += tracks.field('CFA AVG boundary distance').to_f
              sum_cfa_sc += tracks.field('CFA songs count').to_f
              sum_zcr_mis += tracks.field('ZCR missing boundary').to_f
              sum_zcr_wg += tracks.field('ZCR wrongly inserted boundary').to_f
              sum_zcr_ds += tracks.field('ZCR AVG boundary distance').to_f
              sum_zcr_sc += tracks.field('ZCR songs count').to_f
            end
            sum_genre_time += tracks.field('Duration(in secs)').to_i
            sum_time += tracks.field('Duration(in secs)').to_i
          end
        end
        avg_cfa = sum/a[genre].size
        avg_zcr = sum_zcr/a[genre].size
        if type == 'MIXED'
          avg_cfa_mis = sum_cfa_mis/a[genre].size
          avg_cfa_wg = sum_cfa_wg/a[genre].size
          avg_cfa_ds = sum_cfa_ds/a[genre].size
          avg_cfa_sc = sum_cfa_sc/a[genre].size
          avg_zcr_mis = sum_zcr_mis/a[genre].size
          avg_zcr_wg = sum_zcr_wg/a[genre].size
          avg_zcr_ds = sum_zcr_ds/a[genre].size
          avg_zcr_sc = sum_zcr_sc/a[genre].size
        end
        avg_csv << [genre, avg_cfa, avg_zcr, avg_cfa_mis, avg_cfa_wg, avg_cfa_ds,
          avg_zcr_mis, avg_zcr_wg,avg_zcr_ds,avg_cfa_sc,avg_zcr_sc,
          a[genre].size, seconds_to_hours(sum_genre_time),type]
      end
      p seconds_to_days(sum_time)
    end
  end

  def combine_threshold_results
    list = []
    csv_files = Dir.glob(@result_directory+'/**/avg_mp3_output.csv')
    Parallel.map(csv_files, :in_threads => 0) do |csv_file|
      item = CSV.read(csv_file)[1]
      dirname = File.dirname(csv_file)
      item << dirname
      list << item
    end
    #p list
    CSV.open(@result_directory+'/total.csv', 'w') do |avg_csv|
      avg_csv << ['Genre', 'AVG CFA correctness', 'AVG ZCR correctness',
        'AVG CFA missing','AVG CFA wrongly','AVG CFA distance',
        'AVG ZCR missing','AVG ZCR wrongly','AVG ZCR distance',
        'AVG CFA songs count', 'AVG ZCR songs count',
        'Number of Tracks', 'Total duration', 'Type']
      list.each{|row| avg_csv<<row}
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
