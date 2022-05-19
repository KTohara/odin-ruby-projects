require_relative 'board'
require_relative 'player'
require_relative 'display'

# Tic-Tac-Toe game logic
class Game
  include Display
  attr_reader :board, :players, :current_player, :total_symbols

  def initialize
    @board = nil
    @players = []
    @current_player = nil
    @total_names = []
    @total_symbols = []
  end

  def play
    setup_board
    setup_players
    display_lets_play
    play_turns
    game_over
  end

  def setup_board
    display_intro
    @board = Board.new(input_board_size)
    board.create_board
  end

  def setup_players
    (1..total_players).each { |player_num| @players << create_player(player_num) }
    @current_player = players.first
  end

  def input_board_size
    display_board_size_prompt
    begin
      input = Integer(gets)
    rescue
      display_board_size_error
      retry
    else
      input
    end
  end

  def total_players
    display_total_player_prompt
    begin
      input = Integer(gets)
    rescue
      display_total_player_error
      retry
    else
      input
    end
  end

  def create_player(player_num)
    display_create_player_prompt(player_num)
    name = gets.chomp
    while total_names.include?(name)
      display_create_player_error(player_num)
    end
    @total_names << name
    unless total_names.include(name)
    display_create_symbol_prompt(name)
    symbol = create_symbol(name)
    @total_symbols << symbol
    Player.new(name, symbol)
  end

  def create_symbol(name)
    input = gets.chomp
    return input if input.match?(/[^\d]/) && !total_symbols.include?(input)
    display_create_symbol_error(name, input)
    create_symbol(name)
  end

  def play_turns
    until board.full?(total_symbols)
      num = player_turn(current_player)
      board.place_symbol(num, current_player.symbol)
      break if board.win?(current_player.symbol)
      board.show
      @current_player = switch_current_player
    end
  end

  def player_turn(player)
    system('clear')
    board.show
    display_player_turn_prompt(player)
    input = nil
    while input.nil?
      num = gets.chomp.to_i
      if board.valid_move?(num)
        input = num
        break
      end
      display_player_turn_error(player)
    end
    input
  end

  def switch_current_player
    current_player = players.rotate!.first
  end

  def game_over
    board.show
    if board.win?(current_player.symbol)
      display_winner
    else
      display_tie
    end
  end
end

game = Game.new
game.play