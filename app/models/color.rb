class Color < ActiveRecord::Base

  MAX = 15 * 3**0.5

  def self.generate_colors(digits)
    # btw make sure digits come in as strings
    # initialize arrays; one for an array of one digit hex codes, e.g., ['0','5','a']
    ones = []
    # another for two digit hex codes, eg, ['00','05','0a','50',...]; and one for the final three digit codes
    twos = []
    rgbval_array = []

    # just in case, sort digits (this will mainly be useful for the string that will later replace 'custom' with, eg. '05a')

    digits.sort!

    digits.each do |digit|
      ones << digit
    end

    ones.each do |first_digit|
      digits.each do |digit|
        twos << first_digit + digit
      end
    end

    twos.each do |first_two|
      digits.each do |digit|
        rgbval_array << first_two + digit
      end
    end

    # rgbval_array = ['555','55a','5a5','aa5']   #initial static test array
    rgbval_array.each do |rgbval|
      # stop filling array with multiple copies of same color!
      # note: modify this eventually, as dont want to avoid creating of colors in custom set
      # that also exist in other sets
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
