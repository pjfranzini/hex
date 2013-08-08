class Color < ActiveRecord::Base

  MAX = 15 * 3**0.5

  def self.generate_colors#(hex_digit_array)
    #num_digits = hex_digit_array.length
    # hex_digit_array = [0,8]
    # hex_digit_array.each do |hex_digit|
    #   rgbval_array << hex_digit
    # end
    rgbval_array = ['555','55a','5a5','aa5']
    rgbval_array.each do |rgbval|
      # stop filling array with multiple copies of same color!
      unless Color.find_by(rgbvalue: rgbval)
        Color.create [{rgbvalue: rgbval, difficulty_level: "custom"}]
      end
    end
  end

  def color_difference(players_rgbvalue)
  	# magnitude of the vector difference a-b
  	# for 3-digit hex rgb strings thought of as vectors
  	total = 0.0
  	rgbvalue.length.times do |i|
      total += (rgbvalue[i].to_i(16)-players_rgbvalue[i].to_i(16))**2
    end
    total = total ** 0.5
    score = (MAX- total) * 100 /MAX
    #puts score
    # as bad as you can get -- 15 off on each color component --
    # minus what you got, normalized to the maximum, times 100 to give percent
  end

  def is_dark?
    # darkness -- green << red << blue so do a weighted average when deciding to go to white lettering
    total = 0.0
    color_weight = [2,3,1]
    rgbvalue.length.times do |i|
      total += rgbvalue[i].to_i(16) * color_weight[i]
    end
    total/color_weight.sum < 6

  end
end
