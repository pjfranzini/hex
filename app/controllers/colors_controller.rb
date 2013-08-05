class ColorsController < ApplicationController
  # MAX = 15 * 3**0.5
  def display
    @difficulty = params[:difficulty] || "easy"
    session[:difficulty] = @difficulty
    @timer = session[:timer]

    make_session_array_if_needed
  	@computer_color = Color.find_by(rgbvalue: session[:color_array].slice!(0))
    # decrement number of colors left in session
    session[:num_colors] -= 1

    @cumulative_score = session[:cumulative_score] if session[:cumulative_score]
    @max_possible_score = session[:max_possible_score] if session[:max_possible_score]
    @time_bonus = (5-session[:elapsed_time])*10
    session[:start_time] = Time.now if session[:timer]

    respond_to do |format|
    format.html { }
    format.js { }
    end
  end

  def timer_toggle
    session[:timer] = !session[:timer]
    @difficulty = session[:difficulty]
    reset_redirect
  end

  def fresh
    # start a fresh game
    @difficulty = params[:difficulty]
    session[:start_time] = Time.now if session[:timer]
    reset_redirect
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
    session[:elapsed_time] = Time.now - session[:start_time]
    respond_to do |format|
        format.html { }
        format.js { }
    end
  end

  def help
    # since layout uses a color object to set background color, pull up color 2 (white) for background of help page
    @computer_color = Color.find(2)
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

  def reset_everything
    # split off the reset from the check so that it can be used elsewhere
      session[:color_array] = nil
      session[:cumulative_score] = nil
      session[:max_possible_score] = nil
  end

  def reset_redirect
    reset_everything
    redirect_to color_path(@difficulty)
  end
end
