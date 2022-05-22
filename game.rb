# frozen_string_literal: true

require_relative 'board'
require_relative 'player'
require_relative 'display'
require_relative 'messages'

# Tic-Tac-Toe game logic
class Game
  include Display
  include Messages
  attr_reader :board, :players, :symbols, :current_player

  def initialize(board_size, players)
    @board = Board.new(board_size)
    @players = players
    @symbols = players.inject([]) { |acc, player| acc << player.symbol }
    @current_player = @players.first
  end

  def play
    setup_board
    display_lets_play
    play_turns
    game_over
  end

  private

  def setup_board
    board.create_board
  end

  def play_turns
    until board.full?(symbols)
      display_board
      num = current_player.get_position(board)
      board.place_symbol(num, current_player.symbol)
      display_board
      break if board.win?(current_player.symbol)

      cpu_position(current_player, num) if current_player.instance_of?(Computer)
      @current_player = switch_current_player
    end
  end

  def game_over
    display_board
    if board.win?(current_player.symbol)
      add_win(current_player)
      display_board
      message_winner
    else
      message_tie
    end
  end

  def add_win(current_player)
    current_player.wins += 1
  end

  def switch_current_player
    total_rotations = (players.index(current_player) + players.length + 1) % players.length
    @current_player = players.rotate(total_rotations).first
  end
end
