
class GamesController < ActionController::Base
  before_action :current_user
  # before_action :which_player

  def new
  end

  def create
    @game = Game.create(player_1: @current_user)
  end

  def show
  end

  def hit
  end

  def hold
    # @number =
  end

  def over
  end

  def update
    row = params[:coord_row]
    col = params[:coord_row]
    coord = col + ', ' + row
    tile = Tile.find_by(coordinates: coord)
    if tile
      tile.hit = true
      tile.save
    else
      @errors = tile.errors.full_messages
    end
    binding.pry
  end

private

  def fire_params
    params.require(:fire).permit(:coordinates)
  end

  def logged_in?
    session[:user_id]
  end

  def current_user
    if logged_in?
      @current_user = User.find(session[:user_id])
    end
  end

  def which_player
    game = Game.find(params[:id])
    if @current_user == game.player_1
      @current_user = @player_1
    elsif @current_user == game.player_2
      @current_user = @player_2
    end
  end





end
