# frozen_string_literal: true

require_relative 'board'

# Tree node for SuperCPU
class TicTacToeNode
  attr_reader :board, :symbol, :symbols, :prev_move

  def initialize(board, symbol, symbols, prev_move = nil)
    @board = board
    @symbol = symbol
    @symbols = symbols
    @prev_move = prev_move
  end

  def children
    children = []
    board.grid.flatten.each do |num|
      next unless board.valid_move?(num)
      
      dup_board = board.dup
      dup_board.place_symbol(num, symbol)
      children << TicTacToeNode.new(dup_board, next_symbol, symbols, num)
    end
    children
  end

  def losing_node?(eval_sym)
    return board.won? && board.winner != eval_sym if board.over?

    if symbol == eval_sym
      children.all? { |node| node.losing_node?(eval_sym) }
    else
      children.any? { |node| node.losing_node?(eval_sym) }
    end
  end

  def winning_node?(eval_sym)
    return board.winner == eval_sym if board.over?

    if symbol == eval_sym
      children.any? { |node| node.winning_node?(eval_sym) }
    else
      children.all? { |node| node.winning_node?(eval_sym) }
    end
  end

  def next_symbol
    rotations = (symbols.index(symbol) + symbols.length + 1) % symbols.length
    symbols.rotate(rotations).first
  end
end
