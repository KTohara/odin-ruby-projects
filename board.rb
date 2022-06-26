# frozen_string_literal: true

require_relative 'display'

# Board logic
class Board
  include Display
  attr_reader :grid

  def initialize(grid_length)
    @grid = Array.new(grid_length) { [''] * grid_length }
  end

  def create_board
    num = 0
    grid.each do |row|
      row.map! { num += 1 }
    end
  end

  def place_symbol(num, symbol)
    (0...grid.length).each do |i|
      (0...grid.length).each do |j|
        grid[i][j] = symbol if grid[i][j].to_i == num
      end
    end
  end

  def valid_move?(num)
    return false if num.instance_of?(String)

    grid.flatten[(num - 1)] == num
  end

  def valid_pos
    grid.flatten.select { |cell| cell.instance_of?(Integer) }
  end

  def over?
    won? || tied?
  end

  def tied?
    return false if won?

    grid.all? do |row|
      row.all? { |cell| cell.instance_of?(String) }
    end
  end

  def won?
    !winner.nil?
  end

  def winner
    (grid + cols + diagonals).each do |row|
      return row.first if row.all? { |cell| row.first == cell }
    end
    nil
  end

  def cols
    grid.transpose
  end

  def diagonals
    diag = (0...grid.length).map { |i| grid[i][i] }
    antediag = (0...grid.length).map { |i| grid[i][grid.length - 1 - i] }
    [diag] + [antediag]
  end

  def dup
    length = grid.length
    new_board = self.class.new(length)
    new_board.create_board
    (0...length).each do |i|
      (0...length).each do |j|
        new_board.grid[i][j] = grid[i][j]
      end
    end
    new_board
  end
end
