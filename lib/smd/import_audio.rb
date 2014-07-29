require 'securerandom'
require 'taglib'
require 'csv'
require 'fileutils'

module Smd

  class ImportAudio
    def initialize( input_file, type, output_directory )
      @input_file = input_file
      @type = type
      @output_directory = output_directory
      @uuid = SecureRandom.uuid
    end

    def import
      copy_mp3
      generate_cfa_data
      generate_waveform
      generate_metadata
    end

    def generate_cfa_data
      feature_plan =  'yaafe.py -r 11025 --resample'
      feature_plan += ' -f "cfa: SimpleNoiseGate>ContinuousFrequencyActivation '
      feature_plan += 'BinThreshold=10 NbPeaks=40>WindowConvolution WCLength=17" '
      feature_plan += '-p Metadata=False'

      system( feature_plan + ' ' + results_file('mp3') )
    end

    def generate_waveform
      audio_cmd = 'audiowaveform -i '#test.mp3 -o test.dat
      audio_setting = ' -z 256 -b 8'
      system( audio_cmd + results_file('mp3') +' -o ' + results_file('dat') + audio_setting)
    end

    def generate_metadata
      TagLib::FileRef.open( results_file('mp3') ) do |fileref|
        unless fileref.null?
          tag = fileref.tag
          #title = tag.title
          #tag.artist
          #tag.album
          #genre = tag.genre

          properties = fileref.audio_properties
          #duration = properties.length
          CSV.open( results_file('metadata.csv'), 'w') do |music_csv|
            music_csv << [tag.title, tag.artist, 'M', tag.genre, properties.length]
          end
        end
      end
    end

    def copy_mp3
      if @input_file =~ /\.mp3$/
        FileUtils.cp( @input_file, results_file('mp3') )
      else
        system("avconv -i \"#{@input_file}\" #{results_file('mp3')}")
      end
    end

    def results_file(type)
      File.join( @output_directory, @uuid + '.' + type )
    end
  end

end

# importer = ImportAudio.new('test.mp3', 'music', 'results')
# importer.import
