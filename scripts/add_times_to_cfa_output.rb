require 'json'
require 'pp'

def num_mfcc_frames_in_cfa_frames( num_cfa_frames, block_size, step_size )
  block_size + ( num_cfa_frames - 1 ) * step_size
end

def num_samples_in_mfcc_frames( num_mfcc_frames, block_size, step_size )
  block_size + ( num_mfcc_frames - 1 ) * step_size
end

def time_of_one_window (window_block_size, sample_rate, frame_block_size)
  window_block_size / sample_rate * frame_block_size
end

file     = File.open('audio/test.mp3.cfa_2.2.csv') # 2.2 seems to be best fit for this sample

line_num = 0.0

list = [ ]

file.each_line do |line|
  number   = line.to_i
  line_num = line_num + 1

  num_mfcc    = num_mfcc_frames_in_cfa_frames( line_num, 100.0, 50.0 )
  num_samples = num_samples_in_mfcc_frames( num_mfcc, 1024.0, 512.0 )
  time_in_sec = num_samples / 11025.0
  time_gap = time_of_one_window(1024.0, 11025.0, 100.0)
	
  #data[ time_in_sec ] = number
  
  #say music is red, no_music is green.
  if number == 1 
	color = 'rgba(215, 40, 40, 0.9)' # red
  else
	color = 'rgba(75, 213, 44, 0.9)' # green
  end
  
  #centralize the frames
  

  #hash
  data = { }
  data[ :startTime ] = time_in_sec - time_gap #centralize required
  data[ :endTime ] = time_in_sec
  data[ :editable ] = false
  data[ :color ] = color
  data[ :labelText ] = "segment#{line_num.to_i}"
  #add hash to array
  list<<data
  
end

#pp list

#write json
File.open("./audio/test.json","w") do |f|
  f.write(list.to_json)
end

