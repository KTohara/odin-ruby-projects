require_relative 'board.rb'
require_relative 'player.rb'

class Game
  
  attr_reader :board, :first_player, :second_player, :current_player

  def initialize
    @board = nil
    @first_player = nil
    @second_player = nil
    @current_player = nil
  end

  def play
    # set up game
    # board.display
    # play_turns
    # game_over
  end

  def setup_game
    puts "Let's Play Tic-Tac-Toe!"
    puts "Enter the grid size for your game"
    board_size = gets.chomp.to_i
    @board = Board.new(board_size) # add error check for board size
    board.create_board
    board.display
    @first_player = create_player(1)
    @second_player = create_player(2)
  end

  def create_player(player_num)
    puts "Player ##{player_num}, enter your name"
    name = gets.chomp
    puts "#{name}, enter a symbol you'd like as your token"
    symbol = gets.chomp
    Player.new(name, symbol)
  end

  def input_player_turn(player)
    puts "#{player.name}, enter a number to place '#{player.symbol}' at that location"
    num = gets.chomp.to_i
    return num if board.valid_move?(num)

    puts "Sorry #{player.name}, invalid input. Try again"
    player_turn(player)
  end
end

game = Game.new
game.setup_game