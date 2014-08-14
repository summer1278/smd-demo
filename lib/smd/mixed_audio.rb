#$: << 'lib'
require 'csv'
#require 'smd'

module Smd

  class MixedAudio
  	def initialize (ground_truth, segments, duration)
  		@ground_truth = ground_truth
      @segments = segments
      @duration = duration.to_f - 3.0 #remove end bits
  	end

  	def boundary_correctness
  	  #correctness to ground truth, 100ms = 0.1s as one chunk
  	  step_time = 0.1
  	  start_time = 0.0
      end_time = 0.0
      correct = 0.0
      total_tests = @duration/step_time
  	  while end_time < @duration 
  	  	end_time = start_time + step_time
        if is_same_type(@ground_truth, @segments, start_time, end_time)
          correct += 1.0
        end
        start_time += step_time
  	  end
  	  percentage = correct/total_tests
      return percentage
  	end

    def boundary_search
      missing_bound = 0
      slot = 2.0
      sq_distance = []
      unselected_seg = @segments
      @ground_truth.each do |boundary|
        interval_start = ( ((boundary[0].to_f-slot) if boundary[0].to_f>slot) or 0.0 )
        interval_end = ( ((boundary[0].to_f+slot) if boundary[0].to_f+slot<@duration) or @duration )
        found = boundary_found(@segments, boundary[2], interval_start, interval_end)
        if found.empty?
          missing_bound += 1
          #p boundary
        elsif found.size == 1 
          sq_distance << boundary_squared_distance(found.flatten[0].to_f, boundary[0].to_f)
          unselected_seg.delete(found)
          #p unselected_seg
        else
          sq_distance << found.collect{|seg| boundary_squared_distance(seg[0].to_f, boundary[0].to_f)}.min
          selected = found.select{|seg| boundary_squared_distance(seg[0].to_f, boundary[0].to_f)}.min
          unselected_seg.delete(selected)
          #p unselected_seg
        end
      end
      avg_distance = (sq_distance.reduce(0.0){ |sum, el| sum + el.to_f }.to_f)**(1/2) / sq_distance.size
      wongly_inserted_bound = unselected_seg.size
      #p wongly_inserted_bound
      #p missing_bound
      return [missing_bound, wongly_inserted_bound, avg_distance]
    end

    def boundary_squared_distance(current, real)
      (current-real) ** 2
    end

    def is_same_type(truth, segments, start_time, end_time)
      truth.select{|seg| is_in(start_time, end_time, seg[0].to_f, seg[1].to_f)}.flatten[2] ==
        segments.select{|seg| is_in(start_time, end_time, seg[0].to_f, seg[1].to_f)}.flatten[2]
    end

  	def is_in(start_time, end_time, range_start, range_end)
  	  (range_start..range_end).cover?(start_time) && (range_start..range_end).cover?(end_time)
  	end

    def boundary_found(segments, type, range_start, range_end)
      # return array of arrays || empty array for not found
      segments.select{|seg| (range_start..range_end).cover?(seg[0]) && seg[2] == type }
    end

  end
  # file_name = 'results/2a27f3d0-f5e6-4417-a703-c8805e1728d8'
  # cfa = CfaData.new(File.open(file_name+'.mp3.cfa.csv').to_a, 2.2,128,64)
  # cfa_time = cfa.cfa_time
  # zcr = ZcrData.new(CSV.read(file_name+'.mp3.bbc-segments.csv').flatten.compact)
  # zcr_time = zcr.zcr_time(2148)
  # ma = MixedAudio.new CSV.read(file_name+'.truth.csv'),cfa_time,2148
  # ma.boundary_search
end