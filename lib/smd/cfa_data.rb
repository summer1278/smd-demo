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
    classified = @data.map do |i|
      if i.to_f >= @threshold
        1
      else
        0
      end
    end
    ones = classified.select { |i| i == 1 }.size
    percentage = ones.to_f/classified.size.to_f
    if type == 'S'
      percentage = 1 - percentage
    end
    return percentage
  end

end
end
