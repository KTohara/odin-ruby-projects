# frozen_string_literal: true

require_relative 'game'
require_relative 'messages'
require_relative 'display'

# TicTacToe game inputs
class TicTacToe
  include Display
  include Messages

  attr_reader :taken, :board_size, :player_count

  def initialize
    @cpu_names = ['HAL-9000', 'Data', 'Bishop', 'C3P0', 'R2D2', 'Agent Smith', 'T-800', 'T-1000', 'Wall-E']
    @cpu_symbols = ['§', '⁂', '♠', '♣', '♥', '♦', '𝄞', '⚝', '🄋']
    @taken = []
    @board_size = nil
    @player_count = nil
    @players = []
    @replay = false
  end

  def play_game
    input_board_size
    input_total_players
    setup_players
    @game = Game.new(board_size, players)
    game.play
    repeat_game
  end

  def input_board_size
    prompt_board_size
    input = gets.chomp.to_i
    until input.instance_of?(Integer) && input.between?(3, 10)
      error_board_size
      input = gets.chomp.to_i
    end
    @board_size = input
  end

  def input_total_players
    prompt_total_player
    input = gets.chomp.to_i
    until input.instance_of?(Integer) && input.between?(2, 8)
      error_total_player
      input = gets.chomp.to_i
    end
    @player_count = input
  end

  def setup_players
    (1..player_count).each do |player_num|
      type = player_type(player_num)
      name, symbol = create_cpu(player_num) if %w[s c].include?(type)

      name = create_name(player_num)
      symbol = create_symbol(name)

      players << create_player(type, name, symbol)
    end
  end

  def player_type(player_num)
    input = nil
    options = board_size > 3 ? %w[h c] : %w[h c s]
    until options.include?(input)
      board_size > 3 ? prompt_no_scpu(player_num) : prompt_player_type(player_num)
      input = gets.chomp.downcase
    end
    input
  end

  def create_name(player_num)
    prompt_create_name(player_num)
    input = gets.chomp
    while taken.include?(input) && taken.any?
      error_create_name(player_num, input)
      input = gets.chomp
    end
    taken << input
    input
  end

  def create_symbol(name)
    prompt_create_symbol(name)
    input = gets.chomp
    until input.match?(/^[^\d]$/) && !taken.include?(input)
      error_create_symbol(name, input)
      input = gets.chomp
    end
    taken << input
    input
  end

  def create_cpu(player_num)
    name = cpu_names.sample
    cpu_names.delete(name)
    symbol = cpu_symbols.sample
    cpu_symbols.delete(symbol)
    cpu_prompt_creation(player_num, name, symbol)
    [name, symbol]
  end

  def create_player(type, name, symbol)
    case type
    when 'c' then Computer.new(name, symbol)
    when 'h' then Player.new(name, symbol)
    when 's' then SuperCPU.new(name, symbol)
    end
  end

  def repeat_game
    input = nil
    until %w[y n].include?(input)
      message_repeat_game?
      input = gets.chomp.downcase
    end

    play_original_players if input == 'y'
    message_thanks
    exit 0
  end

  def play_original_players
    input = nil
    until %w[y n].include?(input)
      message_play_with_original_players?
      input = gets.chomp.downcase
    end
    input == 'y' ? game.play : play_game
  end

  private

  attr_reader :players, :game
end

TicTacToe.new.play_game
