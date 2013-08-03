class ColorsController < ApplicationController
  # MAX = 15 * 3**0.5
  def display
    reset_everything_if_user_changed_difficulty

    @difficulty = params[:difficulty] || "easy"
    session[:difficulty] = @difficulty

    make_session_array_if_needed
  	@computer_color = Color.find_by(rgbvalue: session[:color_array].slice!(0))
    # decrement number of colors left in session
    session[:num_colors] -= 1

    @cumulative_score = session[:cumulative_score] if session[:cumulative_score]
    @max_possible_score = session[:max_possible_score] if session[:max_possible_score]

    respond_to do |format|
    format.html { }
    format.js { }
    end

  end

  def score
    @computer_color = Color.find(params[:computer_color_id])
    @players_rgbvalue = params[:players_rgbvalue].gsub(/[#]/, '')
    #allow player to input colors with or without # in front
    @score = @computer_color.color_difference(@players_rgbvalue)
    session[:cumulative_score] += @score
    session[:max_possible_score] += 100
    @cumulative_score = session[:cumulative_score]
    @max_possible_score = session[:max_possible_score]
    @difficulty = session[:difficulty]
    @colors_left = session[:num_colors]
    respond_to do |format|
        format.html { }
        format.js { }
    end
  end

  def help
    # since layout uses a color object to set background color, pull up color 2 (white) for background of help page
    @computer_color = Color.find(2)
    # set difficulty to something that doesn't match any of the real difficulties, so that when a player goes back to the game from the help page the game will reset instead of continuing on having missed a color
    session[:difficulty] = 'help'
  end

  def visualize
    # since we don't count on the user putting a #, strip it off if it is there and put it back on
    @see_this_color = '#'+params[:see_this_color].gsub(/[#]/, '')
    @computer_color = Color.find(2)
    # not very dry, but have to keep this color defined
    respond_to do |format|
      format.html { }
      format.js { }
    end

  end

  private
  def make_session_array_if_needed
    # make it unless it already exists
    unless session[:color_array]
      # to maintain memory of color set within a minigame we create a shuffled array once and then reuse it till all the colors are gone
      computer_color_array = Color.where({difficulty_level: @difficulty }).shuffle
      # we create a color array to store in the session because the object array is too big
      color_array = []
      # for each color object, we push its rgbvalue into color array
      computer_color_array.each do |color_obj|
        color_array << color_obj.rgbvalue
      end
      session[:color_array] = color_array
      # store the number of colors so we can deal with what happens when we run out of colors in a set
      session[:num_colors] = color_array.length
      # initialize the score variables
      session[:cumulative_score] = 0
      session[:max_possible_score] = 0
    end
  end

  def reset_everything_if_user_changed_difficulty
    # if there is a difficulty already set in session, and user sends in a different one via params, clear the session memory of color_array and score
    if session[:difficulty] && params[:difficulty] != session[:difficulty]
      session[:color_array] = nil
      session[:cumulative_score] = nil
      session[:max_possible_score] = nil
    end
  end
end
