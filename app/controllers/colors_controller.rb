class ColorsController < ApplicationController
  # MAX = 15 * 3**0.5
  def display
    @difficulty = params[:difficulty]
  	@computer_color = Color.where({difficulty_level: @difficulty }).shuffle.first
  end

  def score
    @computer_color = Color.find(params[:computer_color_id])
    @players_rgbvalue = params[:players_rgbvalue]
    @score = @computer_color.color_difference(@players_rgbvalue)
    respond_to do |format|
        format.html { }
        format.js { }
      end
  end
end
