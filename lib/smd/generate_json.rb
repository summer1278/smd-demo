require 'json'

module Smd
  
  class GenerateJson
  	def initialize(segments, output_directory)
  	  @segments = segments
  	  @output_directory = output_directory
  	  #@file_name = file_name
  	end

  	def generate
  	  list = generate_list_of_segments
  	  write_json(list)
  	end
   
  	def generate_list_of_segments
  	  list = []
  	  @segments.each_with_index do |segment, index|
  	    data = {}
  	    if segment[2] == 'Music' 
	      color = 'rgba(215, 40, 40, 0.9)' # red for music
        else
	      color = 'rgba(75, 213, 44, 0.9)' # green for speech
        end
        data[:startTime] = segment[0]
        data[:endTime] = segment[1]
        data[:editable] = true
        data[:color] = color
        data[:labelText] = "segment#{index}"
        list << data
      end
      return list
  	end
    
    def write_json(list)
      File.open(@output_directory.gsub('.csv','.json'), 'w') do |f|
        f.write(list.to_json)
      end
    end

  end
end