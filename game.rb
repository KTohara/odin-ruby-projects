# frozen_string_literal: true

require_relative 'board'
require_relative 'player'
require_relative 'display'
# require_relative 'stats'

# Tic-Tac-Toe game logic
class Game
  include Display
  attr_reader :board, :players, :current_player, :taken

  def initialize
    @board = nil
    @players = []
    @current_player = nil
    @taken = []
    # @stats = Stats.new(players)
  end

  def play
    setup_board
    setup_players
    display_lets_play
    play_turns
    game_over
  end

  private

  def setup_board
    system('clear')
    puts "\e[1mLets Play...\e[22m\n\n".center(95)
    display_banner
    sleep(2)
    system('clear')
    @board = Board.new(input_board_size)
    board.create_board
  end

  def input_board_size
    display_board_size_prompt
    input = Integer(gets) rescue false
    until input.instance_of?(Integer) && input.between?(3, 10)
      display_board_size_error
      input = Integer(gets) rescue false
    end
    input
  end

  def setup_players
    (1..total_players).each do |player_num| 
      player = Player.new(player_num, taken)
      players << player
      taken << player.symbol
      taken << player.name
    end
    @current_player = players.first
  end

  def total_players
    display_total_player_prompt
    input = Integer(gets) rescue false
    until input.instance_of?(Integer) && input >= 2
      display_total_player_error
      input = Integer(gets) rescue false
    end
    input
  end

  def play_turns
    until board.full?(taken)
      display_play_turn_prompt(current_player)
      num = player_turn(current_player)
      board.place_symbol(num, current_player.symbol)
      break if board.win?(current_player.symbol)

      @current_player = switch_current_player
    end
  end

  def player_turn(player)
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
    @current_player = players.rotate!.first
  end

  def game_over
    board.show
    board.win?(current_player.symbol) ? display_winner : display_tie
  end
end
