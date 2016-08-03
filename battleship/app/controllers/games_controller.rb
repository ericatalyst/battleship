class GamesController < ApplicationController
  before_action :current_user
  before_action :which_player, :current_game, only: [:show, :update, :hit, :hold]

  def new
  end

  def create
    @game = Game.create(player_1: @current_user)
    redirect_to '/hold'
  end

  def show
    if @current_game.player_2 == nil
      @number = @current_game.id
      @message = "Second player has not arrived."
      render 'hold'
    elsif game_over?
      render '/over'
    else
      @opponent_board = @current_game.tiles.where(player_id: opponent.id)
      @your_board = @current_game.tiles.where(player_id: @current_user.id)
    end
    # p_1 = User.first
    # p_2 = User.last
    # @game = Game.create(player_1_id: p_1.id, player_2_id: p_2.id)
    # @game.create_tiles
    # @opponent_board = @game.tiles.where(player_id: opponent(params[:id]).id)
    # if @opponent_board.empty?
    #   @opponent_board = Game.create_opponent_tiles
    # end
    # @your_board = @game.tiles.where(player_id: 1)
  end

  def join
    game = Game.find(params[:game_id])
    game.player_2 = @current_user
    game.save
    redirect_to "/games/#{params[:id]}"
  end


  def hit

  end

  def hold
    @number = @current_game.id
  end

  def over
    if @current_user == User.find(@current_game.winner_id)
  end

  def update
    row = fire_params[:row]
    col = fire_params[:column]
    coord = col + ', ' + row
    tile = Tile.find_by(coordinates: coord)
    if tile
      tile.hit = true
      tile.save
      if ship_hit(tile)
        redirect_to '/hit'
      else
        redirect_to '/show'
      end
    else
      render 'show'
      @errors = tile.errors.full_messages
    end
  end

private

  def fire_params
    params.require(:fire).permit(:row, :column)
  end

  def logged_in?
    session[:user_id]
  end

  def current_user
    if logged_in?
      @current_user = User.find(session[:user_id])
    end
  end

  def current_game
    @current_game = Game.find(params[:id])
  end

  def which_player
    game = Game.find(params[:id])
    if @current_user == game.player_1
      @current_user = @player_1
    elsif @current_user == game.player_2
      @current_user = @player_2
    end
  end

  def opponent
    if which_player == @current_game.player_1
      @current_game.player_2
    elsif which_player == @current_game.player_2
      @current_game.player_1
    end
  end

  def ship_hit(tile)
    opp_tile = @opponent.tiles.find_by(coordinates: tile.coordinates)
    if opp_tile.ship_id == nil
      false
    else
      Ship.find(opp_tile.ship_id).type
  end

  def game_over?
    p1_ships = @current_game.ships.where(player_id: @current_user)
    p1_ships.each do |ship|
        p1_in_use = ship.tiles.take_while { |tile| tile.hit == true }
    end
    p2_ships = @current_game.ships.where(player_id: @opponent)
    p2_ships.each do |ship|
        p2_in_use = ship.tiles.take_while { |tile| tile.hit == true }
    end
    if p1_in_use.empty? || p2_in_use.empty?
      true
    else
      false
    end
  end

end