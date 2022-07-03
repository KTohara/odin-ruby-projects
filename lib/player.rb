# frozen_string_literal: true

require_relative 'display'
require_relative 'messages'
require_relative 'node'

# Player class
class Player
  include Display
  include Messages

  attr_reader :name, :symbol
  attr_accessor :wins

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
    @wins = 0
  end

  def get_position(board, _symbols)
    prompt_get_position(self)
    input = gets.chomp.to_i
    until board.valid_move?(input)
      error_get_position(self)
      input = gets.chomp.to_i
    end
    input
  end

  # private

  # def create_name(player_num, taken)
  #   prompt_create_name(player_num)
  #   input = gets.chomp
  #   while taken.include?(input) && taken.any?
  #     error_create_name(player_num, input)
  #     input = gets.chomp
  #   end
  #   taken << input
  #   input
  # end

  # def create_symbol(name, taken)
  #   prompt_create_symbol(name)
  #   input = gets.chomp
  #   until input.match?(/^[^\d]$/) && !taken.include?(input)
  #     error_create_symbol(name, input)
  #     input = gets.chomp
  #   end
  #   taken << input
  #   input
  # end
end

# Computer class
class Computer
  include Messages
  include Display

  # class << self
  #   attr_reader :cpu_names, :cpu_symbols
  # end

  # @cpu_names = ['HAL-9000', 'Data', 'Bishop', 'C3P0', 'R2D2', 'Agent Smith', 'T-800', 'T-1000', 'Wall-E']
  # @cpu_symbols = ['§', '⁂', '♠', '♣', '♥', '♦', '𝄞', '⚝', '🄋']

  attr_reader :name, :symbol
  attr_accessor :wins

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
    @wins = 0
  end

  def get_position(board, symbols)
    cpu_prompt_thinking(name, symbol)
    win_move(board) || block_move(board, symbols) || random_move(board)
  end

  private

  # def create_cpu(player_num)
  #   @name = Computer.cpu_names.sample
  #   @symbol = Computer.cpu_symbols.sample
  #   Computer.cpu_names.delete(name)
  #   Computer.cpu_symbols.delete(symbol)
  #   cpu_prompt_creation(player_num, self)
  # end

  def win_move(board)
    (1..board.grid.length**2).each do |num|
      dup_board = board.dup
      next unless dup_board.valid_move?(num)

      dup_board.place_symbol(num, symbol)
      if dup_board.winner == symbol
        cpu_prompt_win(self, num)
        return num
      end
    end
    nil
  end

  def block_move(board, symbols)
    (1..board.grid.length**2).each do |num|
      dup_board = board.dup
      next unless dup_board.valid_move?(num)

      symbols = symbols.reject { |sym| sym == symbol }
      symbols.each do |sym|
        dup_board.place_symbol(num, sym)
        if dup_board.winner == sym
          cpu_prompt_block(self, num)
          return num
        end
      end
    end
    nil
  end

  def random_move(board)
    move = board.valid_pos.sample
    cpu_prompt_random_move(self, move)
    move
  end
end

# CPU using DFS to calculate move
class SuperCPU < Computer
  def get_position(board, symbols)
    node = TicTacToeNode.new(board, symbol, symbols)
    possible_moves = node.children.shuffle

    node = possible_moves.find { |child| child.winning_node?(symbol) }

    if node
      cpu_prompt_thinking(name, symbol)
      cpu_prompt_random_move(self, node.prev_move)
      return node.prev_move
    end

    node = possible_moves.find { |child| !child.losing_node?(symbol) }

    if node
      cpu_prompt_thinking(name, symbol)
      cpu_prompt_random_move(self, node.prev_move)
      return node.prev_move
    end

    raise 'I cannot lose!'
  end
end
