require 'json'
require 'pp'

def num_frames_in_a_block( num_blocks, block_size, step_size )
  block_size + ( num_blocks - 1 ) * step_size
end

def num_samples_in_a_window( num_frames, block_size, step_size )
  block_size + ( num_frames - 1 ) * step_size
end

def time_of_one_window (window_block_size, sample_rate, block_frame_size)
  window_block_size / sample_rate * block_frame_size
end

file     = File.open('audio/test.mp3.cfa_2.2.csv') # 2.2 seems to be best fit for this sample

lines    = file.to_a
total_segments = lines.size
#puts total_segments

# some presits
time_slot = time_of_one_window(1024.0, 11025.0, 100.0)

time_start_offset = time_slot * 0.25

time_end_offset = time_slot * 0.50

line_num = 0.0

list = [ ]

lines.each do |line|
  number   = line.to_i
  line_num = line_num + 1

  num_frames   = num_frames_in_a_block( line_num, 100.0, 50.0 )
  num_samples = num_samples_in_a_window( num_frames, 1024.0, 512.0 ) 
  time_in_sec = num_samples / 11025.0
  
  
  # say music is red, no_music is green.
  if number == 1 
	color = 'rgba(215, 40, 40, 0.9)' # red
  else
	color = 'rgba(75, 213, 44, 0.9)' # green
  end
  

  #hash
  data = { }
  
  temp_start = time_in_sec - time_slot + time_start_offset # add offset
  if temp_start < 0
	temp_start =  0 # remove negative start times
  end
  
  temp_end = time_in_sec - time_end_offset # substract offset
  
  if line_num == total_segments 
	temp_end = time_in_sec # last: to the end
  end
  
  # merge same-label segments into one
  if list.last && list.last[:endTime] == temp_start.round(2) && list.last[:color] == color
    list.last[:endTime]  =  temp_end.round(2)
  else
    data[ :startTime ] = temp_start.round(2)
    data[ :endTime ] = temp_end.round(2)
    data[ :editable ] = true
    data[ :color ] = color
    data[ :labelText ] = "segment#{line_num.to_i}"
    #add hash to array
    list << data
  end
  
  
end

 pp list


#write json
File.open("./audio/test.json","w") do |f|
  f.write(list.to_json)
end

