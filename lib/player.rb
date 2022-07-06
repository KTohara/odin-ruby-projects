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
end

# Computer class
class Computer
  include Messages
  include Display

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
