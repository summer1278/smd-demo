module Smd

  class CfaProcessor

    def initialize( input_file, output_directory, feature_plan = {} )
      @input_file = input_file
      @output_directory = output_directory
      @bin_threshold = feature_plan[:bin_threshold] || 0.1
      @nb_peaks = feature_plan[:nb_peaks] || 5
      @nb_run_avg_frames = feature_plan[:nb_run_avg_frames] || 21
      @nb_sum_frames = feature_plan[:nb_sum_frames] || 100
      @step_nb_sum_frames = feature_plan[:step_nb_sum_frames] || 50
      @block_size = feature_plan[:block_size] || 1024
      @step_size = feature_plan[:step_size] || 512
    end

    def process
      plan =  'yaafe.py -r 11025 --resample'
      plan += ' -f "cfa: SimpleNoiseGate>ContinuousFrequencyActivation '
      plan += 'BinThreshold=' + @bin_threshold.to_s + ' '
      plan += 'NbPeaks=' + @nb_peaks.to_s + ' '
      plan += 'NbRunAvgFrames=' + @nb_run_avg_frames.to_s + ' '
      plan += 'NbSumFrames=' + @nb_sum_frames.to_s + ' '
      plan += 'StepNbSumFrames=' + @step_nb_sum_frames.to_s + ' '
      plan += 'blockSize=' + @block_size.to_s + ' '
      plan += 'stepSize=' + @step_size.to_s + ' '
      plan += '>WindowConvolution WCLength=17" '
      plan += '-p Metadata=False -b'

      system( plan + ' ' + @output_directory + ' ' + @input_file )
    end

  end

end

# $: << 'lib'
# require 'smd'
# require 'parallel'

# feature_plans = [
#   { :block_size => 512, :step_size => 256 },
#   { :block_size => 256, :step_size => 128 },
#   { :block_size => 128, :step_size => 64 },
#   { :bin_threshold => 10 },
#   { :bin_threshold => 5 },
#   { :bin_threshold => 2.5 },
#   { :bin_threshold => 1.25 },
#   { :bin_threshold => 6.25 },
# ]

# input_files = Dir.glob('results/test3/*.mp3')

# Parallel.map( input_files, :in_processes => 32 ) do
#   feature_plans.each_with_index do |plan, i|
#    Smd::CfaProcessor.new( 'test.mp3', 'results-' + i.to_s, plan ).process
#  end
# end