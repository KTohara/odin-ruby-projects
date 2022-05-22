# frozen_string_literal: true

require_relative 'game'
require_relative 'messages'
require_relative 'display'

# TicTacToe game inputs
class TicTacToe
  extend Display
  extend Messages

  def self.play_game(replay = false, game = nil)
    game ||= Game.new(input_board_size, setup_players(total_players, replay))
    game.play
    repeat_game(game)
  end

  private

  def self.input_board_size
    prompt_board_size
    input = Integer(gets) rescue false
    until input.instance_of?(Integer) && input.between?(3, 10)
      error_board_size
      input = Integer(gets) rescue false
    end
    input
  end

  def self.setup_players(total_players, replay)
    return if replay

    taken = []
    (1..total_players).inject([]) do |players, player_num|
      is_computer_player = cpu?(player_num)
      player = is_computer_player ? Computer.new(player_num) : Player.new(player_num, taken)
      players << player
    end
  end

  def self.total_players
    prompt_total_player
    input = Integer(gets) rescue false
    until input.instance_of?(Integer) && input.between?(2, 8)
      error_total_player
      input = Integer(gets) rescue false
    end
    input
  end

  def self.cpu?(player_num)
    prompt_cpu_player(player_num)
    case gets.chomp.downcase
    when 'c'
      true
    when 'h'
      false
    else
      cpu?(player_num)
    end
  end

  def self.repeat_game(game)
    print "Play another game? (y)es/(n)o \n> "
    case gets.chomp.downcase
    when 'y'
      original_players
    when 'n'
      puts "\e[1mThanks for Playing!\e[22m"
      exit 0
    else
      repeat_game(game)
    end
  end

  def self.original_players
    print "Play with original players? (y)es/(n)o \n> "
    case gets.chomp.downcase
    when 'y'
      play_game(true, game)
    when 'n'
      play_game
    else
      repeat_game(game)
    end
  end
end

TicTacToe.play_game
