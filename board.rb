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
    grid.each_index do |i|
      grid.each_index do |j|
        grid[i][j] = symbol if grid[i][j].to_i == num
      end
    end
  end

  def valid_move?(num)
    grid.flatten[(num - 1)] == num
  end

  def valid_pos
    grid.flatten.select { |el| el.instance_of?(Integer) }
  end

  def full?(symbols)
    board_array = grid.flatten
    board_array.all? { |cell| symbols.include?(cell) }
  end

  def win?(symbol)
    win_row?(symbol) || win_col?(symbol) || win_diag?(symbol)
  end

  def win_row?(symbol)
    grid.any? do |row|
      row.all? { |cell| cell == symbol }
    end
  end

  def win_col?(symbol)
    col = grid.map.with_index do |_, i|
      grid.map.with_index do |_, j|
        grid[j][i]
      end
    end

    col.any? do |row|
      row.all? { |cell| cell == symbol }
    end
  end

  def win_diag?(symbol)
    length = grid.length
    left_to_right = (0...length).all? { |i| grid[i][i] == symbol }

    right_to_left = (0...length).all? do |i|
      j = length - 1 - i
      grid[i][j] == symbol
    end

    left_to_right || right_to_left
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
