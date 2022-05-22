# frozen_string_literal: true

require_relative 'display'
require_relative 'messages'

# Player class
class Player
  include Display
  include Messages
  attr_reader :name, :symbol
  attr_accessor :wins

  def initialize(player_num, taken)
    @name = create_name(player_num, taken)
    @symbol = create_symbol(name, taken)
    @wins = 0
  end

  def get_position(board)
    prompt_get_position(self)
    input = gets.chomp.to_i
    until board.valid_move?(input)
      error_get_position(self)
      input = gets.chomp.to_i
    end
    input
  end

  private

  def create_name(player_num, taken)
    prompt_create_name(player_num)
    input = gets.chomp
    while taken.include?(input) && taken.any?
      error_create_name(player_num, input)
      input = gets.chomp
    end
    taken << input
    input
  end

  def create_symbol(name, taken)
    prompt_create_symbol(name)
    input = gets.chomp
    until input.match?(/^[^\d]$/) && !taken.include?(input)
      error_create_symbol(name, input)
      input = gets.chomp
    end
    taken << input
    inputn
  end
end

# Computer class
class Computer
  include Messages
  include Display
  attr_reader :name, :symbol
  attr_accessor :wins

  @@cpu_names = ['HAL-9000', 'Data', 'Bishop', 'C3P0', 'R2D2', 'Agent Smith', 'T-800', 'T-1000', 'Wall-E']
  @@cpu_symbols = ['§', '⁂', '♠', '♣', '♥', '♦', '𝄞', '⚝', '🄋']

  def initialize(player_num)
    @wins = 0
    create_cpu(player_num)
  end

  def get_position(board)
    board.valid_pos.sample
  end

  private

  def create_cpu(player_num)
    @name = @@cpu_names.sample
    @symbol = @@cpu_symbols.sample
    @@cpu_names.delete(name)
    @@cpu_symbols.delete(symbol)
    cpu_prompt_creation(player_num, self)
  end
end
