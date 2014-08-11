require 'csv'
require 'pp'

module Smd

  class ZcrData
  def initialize ( segments )
    @segments = segments
  end

  def zcr_percentage ( type, duration )
	  num_seg = ( @segments.size )/3
	  #p num_seg
	  if num_seg == 1 
	  	if @segments[3] == 'Music'
	  	  percentage = 1
	  	else
	  	  percentage = 0
	  	end
	  else
	  	count = num_seg
	  	music_duration = 0.0
	  	while count > 0
	  	  if @segments[count*3+3] == 'Music'
	  	  	if count == num_seg
	  	  	  music_duration += duration - @segments[(count-1)*3+1].to_f
	  	  	else
	          music_duration += @segments[count*3+1].to_f - @segments[(count-1)*3+1].to_f
	    	end
	        #p music_duration
	      end
	        count -= 1
	  	end
		percentage = music_duration/duration.to_f
	  end
	  if type == 'S'
	      percentage = 1 - percentage
	  end
    return percentage
  end

  def zcr_time ( duration )
  	#@segments.shift # remove first
  	time = []  	
  	num_seg = ( @segments.size )/3
  	if num_seg == 1 
  	  time << @segments
  	else
  	  count = num_seg
  	  for i in 0..count-1
  	  	start_time = @segments[i*3+1].to_f.round(2)
  	  	#p start_time
  	  	if i == count-1
          end_time = duration
  	  	else
  	  	  end_time = @segments[(i+1)*3+1].to_f.round(2)
  	  	end
  	  	type = @segments[i*3+3]
  	  	time << [start_time, end_time, type]
  	  end
  	end
  	return time
  end
 
end
  # zcr = ZcrData.new(CSV.read('results/0bce9608-16c6-4610-a603-03d0d7f982a3.mp3.bbc-segments.csv').flatten.compact)
  # zcr.zcr_time(2148)
end



