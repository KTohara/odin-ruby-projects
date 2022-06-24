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

  def get_position(game)
    prompt_get_position(self)
    input = gets.chomp.to_i
    until game.board.valid_move?(input)
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
    input
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

  # game.board.place_symbol(1, '§')
  # game.board.place_symbol(4, '§')
  # game.board.place_symbol(6, '@')
  # game.board.place_symbol(9, '@')

  def get_position(game)
    cpu_prompt_thinking(name, symbol)
    win_move(game) || block_move(game) || random_move(game)
    # input = win_move(game.board, game.symbols)
    # cpu_prompt_win(self, input)
    # if !block_move(game.board, game.symbols).nil?
    #   input = block_move(game.board, game.symbols)
    #   cpu_prompt_block(self, input)
    # input = game.board.valid_pos.sample
    # cpu_prompt_random_move(self, input)
  end

  private

  def create_cpu(player_num)
    @name = @@cpu_names.sample
    @symbol = @@cpu_symbols.sample
    @@cpu_names.delete(name)
    @@cpu_symbols.delete(symbol)
    cpu_prompt_creation(player_num, self)
  end

  def win_move(game)
    (1..game.board.grid.flatten.length).each do |num|
      dup_board = game.board.dup
      next unless dup_board.valid_move?(num)

      dup_board.place_symbol(num, symbol)
      if dup_board.win?(symbol)
        cpu_prompt_win(self, num)
        return num
      end
    end
    nil
  end

  def block_move(game)
    (1..game.board.grid.flatten.length).each do |num|
      dup_board = game.board.dup
      next unless dup_board.valid_move?(num)

      symbols = game.symbols.reject { |sym| sym == symbol }
      symbols.each do |sym|
        dup_board.place_symbol(num, sym)
        if dup_board.win?(sym)
          cpu_prompt_block(self, num)
          return num
        end
      end
    end
    nil
  end

  def random_move(game)
    move = game.board.valid_pos.sample
    cpu_prompt_random_move(self, move)
    move
  end
end

class SuperCPU < Computer
  def get_position(game, symbol); end
end
