# frozen_string_literal: true

require_relative 'game'
require_relative 'messages'
require_relative 'display'
require 'byebug'
# TicTacToe game inputs
class TicTacToe
  extend Display
  extend Messages

  def self.play_game(replay = nil, game = nil)
    game ||= Game.new(input_board_size, setup_players(total_players, replay))
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

  def self.setup_players(total_players, replay)
    return if replay

    taken = []
    (1..total_players).inject([]) do |players, player_num|
      player = case cpu?(player_num)
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

  def self.cpu?(player_num)
    input = nil
    until %w[h c s].include?(input)
      prompt_cpu_player(player_num)
      input = gets.chomp.downcase
    end
    input
  end

  def self.repeat_game(game)
    input = nil
    until %w[y n].include?(input)
      print "Play another game? (y)es/(n)o \n> "
      input = gets.chomp.downcase
    end
    if input == 'y'
      play_original_players(game)
    else
      puts "\e[1mThanks for Playing!\e[22m"
      exit 0
    end
  end

  def self.play_original_players(game)
    input = nil
    until %w[y n].include?(input)
      print "Play with original players? (y)es/(n)o \n> "
      input = gets.chomp.downcase
    end
    input == 'y' ? play_game(true, game) : play_game
  end
end

TicTacToe.play_game
