class ColorsController < ApplicationController
  MAX = 15 * 3**0.5
  def display
  	@rand_color = Color.all.shuffle.first.rgbvalue
  end
  def string_difference(a,b)
  	# magnitude of the vector difference a-b
  	# for 3-digit hex rgb strings thought of as vectors
  	total = 0.0
  	a.length.times do |i|
      total = total + (a[i].to_i(16)-b[i].to_i(16))**2
    end
    total = total ** 0.5
    score = (MAX- total) * 100 /MAX
    #puts score
    # as bad as you can get -- 15 off on each color component --
    # minus what you got, normalized to the maximum, times 100 to give percent
  end

  def score
    @original_color = params[:original_color]
    @players_color = params[:players_color]
    @score = string_difference(@original_color,@players_color)
  end
end
