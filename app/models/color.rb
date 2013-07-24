class Color < ActiveRecord::Base

  MAX = 15 * 3**0.5

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
    total = 0.0
    rgbvalue.length.times do |i|
      total += rgbvalue[i].to_i(16)
    end
    total/3 < 7

  end
end
