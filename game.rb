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
    display_board
    play_turns
    game_over
  end

  private

  def setup_board
    board.create_board
  end

  def play_turns
    until board.full?(symbols)
      num = current_player.get_position(board, symbols)
      board.place_symbol(num, current_player.symbol) if current_player.instance_of?(Player)
      display_board
      break if board.win?(current_player.symbol)

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
    # can't use rotate! - breaks display
    total_rotations = (players.index(current_player) + players.length + 1) % players.length
    @current_player = players.rotate(total_rotations).first
  end
end

# board = Board.new(3)
# board.create_board
# cpu = Computer.new(1)
# board.place_symbol(1, '#')
# board.place_symbol(2, '#')
# board.place_symbol(3, '@')
# board.place_symbol(4, '@')
# board.place_symbol(5, '@')
# board.place_symbol(6, '#')
# board.place_symbol(7, '@')
# board.place_symbol(8, '@')
# board.place_symbol(9, '@')

# p board.win_diag?('@')
# [["#", "#", "@"], ["@", "@", "#"], ["#", "@", "@"]]
# p cpu.possible_moves(board, ['@', '#'])
# p cpu.get_position(board, ['@', '#'])
# g = Game.new(3, [cpu])
# g.board.create_board
# g.play_turns
