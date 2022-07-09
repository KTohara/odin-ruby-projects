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
    @symbols = players.map(&:symbol)
    @current_player = @players.first
  end

  def play
    board.create_board
    display_lets_play
    display_board(self)
    play_turns
    game_over
  end

  def play_turns
    loop do
      num = current_player.get_position(board, symbols)
      board.place_symbol(num, current_player.symbol)
      display_board(self)
      break if board.over?

      @current_player = next_player
    end
  end

  def game_over
    display_board(self)
    if board.won?
      add_win(current_player)
      display_board(self)
      message_winner
    else
      message_tie
    end
  end

  private

  def add_win(current_player)
    current_player.wins += 1
  end

  def next_player
    # can't use rotate! - breaks display
    total_rotations = (players.index(current_player) + players.length + 1) % players.length
    players.rotate(total_rotations).first
  end
end
