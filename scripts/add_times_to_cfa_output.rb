require 'json'
require 'pp'

def num_mfcc_frames_in_cfa_frames( num_cfa_frames, block_size, step_size )
  block_size + ( num_cfa_frames - 1 ) * step_size
end

def num_samples_in_mfcc_frames( num_mfcc_frames, block_size, step_size )
  block_size + ( num_mfcc_frames - 1 ) * step_size
end


file     = File.open('audio/test.mp3.cfa.csv')

line_num = 0.0

list = [ ]

file.each_line do |line|
  number   = line.to_i
  line_num = line_num + 1

  num_mfcc    = num_mfcc_frames_in_cfa_frames( line_num, 100.0, 50.0 )
  num_samples = num_samples_in_mfcc_frames( num_mfcc, 1024.0, 256.0 )
  time_in_sec = num_samples / 11025.0
	
  #data[ time_in_sec ] = number
  
  #say speech is red, music is green.
  if number == 1 
	color = 'rgba(215, 40, 40, 0.9)' # red
  else
	color = 'rgba(75, 213, 44, 0.9)' # green
  end

  #hash
  data = { }
  data[ :startTime ] = time_in_sec - 2.6 #overlapped & first segment starts at < 0, need fix
  data[ :endTime ] = time_in_sec
  data[ :editable ] = true
  data[ :color ] = color
  data[ :labelText ] = "segment#{line_num.to_i}"
  #add hash to array
  list<<data
  
end

#p list.to_json

File.open("./audio/test.json","w") do |f|
  f.write(list.to_json)
end

