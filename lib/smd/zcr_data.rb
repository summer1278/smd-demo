require 'csv'

module Smd

  class ZcrData
  def initialize ( segments )
    @segments = segments
  end

  def zcr_percentage ( type,duration )
	  num_seg = ( @segments.size )/3
	  #p num_seg
	  if 
	  	num_seg == 1 
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
	        music_duration += @segments[count*3+1].to_f - @segments[(count-1)*3+1].to_f
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

end
end



