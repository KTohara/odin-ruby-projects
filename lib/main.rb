# frozen_string_literal: true

require_relative 'game'
require_relative 'messages'
require_relative 'display'

# TicTacToe game inputs
class TicTacToe
  extend Display
  extend Messages

  def self.play_game(replay = nil, game = nil)
    game ||= Game.new(board_size = input_board_size, setup_players(total_players, replay, board_size))
    game.play
    repeat_game(game)
  end

  def self.input_board_size
    prompt_board_size
    input = gets.chomp.to_i
    until input.instance_of?(Integer) && input.between?(3, 10)
      error_board_size
      input = gets.chomp.to_i
    end
    input
  end

  def self.setup_players(player_count, replay, board_size)
    return if replay

    taken = []
    (1..player_count).inject([]) do |players, player_num|
      player = case player_type(player_num, board_size)
               when 'c' then Computer.new(player_num)
               when 'h' then Player.new(player_num, taken)
               when 's' then SuperCPU.new(player_num)
               end
      players << player
    end
  end

  def self.total_players
    prompt_total_player
    input = gets.chomp.to_i
    until input.instance_of?(Integer) && input.between?(2, 8)
      error_total_player
      input = gets.chomp.to_i
    end
    input
  end

  def self.player_type(player_num, board_size)
    input = nil
    options = board_size > 3 ? %w[h c] : %w[h c s]
    until options.include?(input)
      board_size > 3 ? prompt_no_scpu(player_num) : prompt_player_type(player_num)
      input = gets.chomp.downcase
    end
    input
  end

  def self.repeat_game(game)
    input = nil
    until %w[y n].include?(input)
      message_repeat_game?
      input = gets.chomp.downcase
    end
    if input == 'y'
      play_original_players(game)
    else
      message_thanks
      exit 0
    end
  end

  def self.play_original_players(game)
    input = nil
    until %w[y n].include?(input)
      message_play_with_original_players?
      input = gets.chomp.downcase
    end
    input == 'y' ? play_game(true, game) : play_game
  end
end

TicTacToe.play_game
