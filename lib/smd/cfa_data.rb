require 'csv'

module Smd

  class CfaData
    def initialize( data, threshold )
      @data = data
      @threshold = threshold
    end

    def avg_cfa
     @data.reduce(0.0){ |sum, el| sum + el.to_f }.to_f / @data.size
   end

   def cfa_percentage( type )
    classified = @data.map {|i| classify(i.to_f)}
    ones = classified.select { |i| i == 1 }.size
    percentage = ones.to_f/classified.size.to_f
    if type == 'S'
      percentage = 1 - percentage
    end
    return percentage
  end

  def classify ( number )
    if number >= @threshold
      1
    else
      0
    end
  end
  
  def cfa_time
    total_segments = @data.size
    time_slot = time_of_one_block(1024.0, 11025.0, 100.0, 512.0)
    time_start_offset = time_slot * 0.25
    time_end_offset = time_slot * 0.25

    line_num = 0.0

    segments = [ ]
    segment = Array.new(3, nil)

    lines.each do |line|
      number   = classify(line.to_f)
      line_num = line_num + 1

      num_frames   = num_frames_in_a_block( line_num, 100.0, 50.0 )
      num_samples = num_samples_in_a_window( num_frames, 1024.0, 512.0 ) 
      time_in_sec = num_samples / 11025.0
      
      if number == 1
        segment[2] == 'Music'
      else
        segment[2] == 'Speech'
      end

      temp_start = time_in_sec - time_slot + time_start_offset # add offset
      if temp_start < 0 || line_num == 1
        temp_start =  0 # remove negative start times
      end
      temp_end = time_in_sec - time_end_offset # substract offset
      if line_num == total_segments 
        temp_end = time_in_sec # last: to the end
      end
      
      if segments.last && segments.last[1] == temp_start && segments.last[2] == segment[2]
        segments.last = temp_end
      else
        segment[0] = temp_start
        segment[1] = temp_end
        #segment[2] = segment[2]
        segments << segment
      end
      return segments
    end
  end

  def num_frames_in_a_block( num_blocks, block_size, block_step_size )
    block_size + ( num_blocks - 1 ) * block_step_size
  end

  def num_samples_in_a_window( num_frames, window_size, window_step_size )
    window_size + ( num_frames - 1 ) * window_step_size
  end

  def time_of_one_block (window_size, sample_rate, block_size, window_step_size)
    window_size / sample_rate  * block_size *(window_step_size/window_size)
  end

end
end
