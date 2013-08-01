class ColorsController < ApplicationController
  # MAX = 15 * 3**0.5
  def display
    reset_color_array_if_user_changed_difficulty

    @difficulty = params[:difficulty] || "easy"
    session[:difficulty] = @difficulty

    make_session_array_if_needed
  	@computer_color = Color.find_by(rgbvalue: session[:color_array].slice!(0))

  end

  def score
    @computer_color = Color.find(params[:computer_color_id])
    @players_rgbvalue = params[:players_rgbvalue]
    @score = @computer_color.color_difference(@players_rgbvalue)
    @difficulty = session[:difficulty]
    respond_to do |format|
        format.html { }
        format.js { }
      end
  end
  private
  def make_session_array_if_needed
    unless session[:color_array]
      # to maintain memory of color set within a minigame we create a shuffled array once and then reuse it till all the colors are gone
      @computer_color_array = Color.where({difficulty_level: @difficulty }).shuffle
      # we create a color array to store in the session because the object array is too big
      color_array = []
      @computer_color_array.each do |color_obj|
        color_array << color_obj.rgbvalue
      end
      session[:color_array] = color_array
    end
  end
  def reset_color_array_if_user_changed_difficulty
    if session[:difficulty] && params[:difficulty] != session[:difficulty]
      session[:color_array] = nil
    end
  end
end
