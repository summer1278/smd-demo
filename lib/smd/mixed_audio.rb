#$: << 'lib'
require 'csv'
#require 'smd'

module Smd

  class MixedAudio
  	def initialize (ground_truth, cfa_segments, zcr_segments, duration)
  		@ground_truth = ground_truth
      @cfa_segments = cfa_segments
      @zcr_segments = zcr_segments
      @duration = duration - 3.0 #remove end bits
  	end

  	def boundary_correctness 
  	  #correctness to ground truth, 100ms = 0.1s as one chunk
  	  step_time = 0.1
  	  start_time = 0.0
      end_time = 0.0
      cfa_correct = 0.0
      zcr_correct = 0.0
      total_tests = @duration/step_time
  	  while end_time < @duration 
  	  	end_time = start_time + step_time
        if is_same_type(@ground_truth, @cfa_segments, start_time, end_time)
          cfa_correct += 1.0
        end
        if is_same_type(@ground_truth, @zcr_segments, start_time, end_time)
          zcr_correct += 1.0
        end
        start_time += step_time
  	  end
  	  cfa_percentage = cfa_correct/total_tests
      zcr_percentage = zcr_correct/total_tests
      return [cfa_percentage, zcr_percentage]
  	end

    def is_same_type(truth, segments, start_time, end_time)
      truth.select{|seg| is_in(start_time, end_time, seg[0].to_f, seg[1].to_f)}.flatten[2] ==
        segments.select{|seg| is_in(start_time, end_time, seg[0].to_f, seg[1].to_f)}.flatten[2]
    end

  	def is_in(start_time, end_time, range_start, range_end)
  	  (range_start..range_end).cover?(start_time) && (range_start..range_end).cover?(end_time)
  	end

    def boundary_distance
      
    end

  end
  # file_name = 'results/0bce9608-16c6-4610-a603-03d0d7f982a3'
  # cfa = CfaData.new(File.open(file_name+'.mp3.cfa.csv').to_a, 2.2)
  # cfa_time = cfa.cfa_time
  # zcr = ZcrData.new(CSV.read(file_name+'.mp3.bbc-segments.csv').flatten.compact)
  # zcr_time = zcr.zcr_time(2148)
  # ma = MixedAudio.new CSV.read(file_name+'.truth.csv'),cfa_time,zcr_time
  # ma.boundary_correctness(2148)

end