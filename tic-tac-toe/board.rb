# frozen_string_literal: true

require_relative 'display'

# Tic-Tac-Toe Board
class Board
  include Display
  attr_reader :grid, :grid_length

  def initialize(grid_length)
    @grid = Array.new(grid_length) { [''] * grid_length }
    @grid_length = grid_length
  end

  def create_board
    num = 0
    grid.each do |row|
      row.map! { num += 1 }
    end
  end

  def show
    system('clear')
    sleep(0.05)
    grid = display_grid(grid_length)
    grid.each.with_index do |row, i|
      num_row = " #{row.join(" \e[36m|\e[0m ")} "
      puts num_row
      puts display_grid_decorations unless i == grid_length - 1
    end
    puts
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

  def full?(symbols)
    board_array = grid.flatten
    board_array.all? { |cell| symbols.include?(cell) }
  end

  def win?(symbol)
    win_row?(symbol) || win_col?(symbol) || win_diag?(symbol)
  end

  # private

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
    left_to_right = (0...grid.length).all? do |i|
      grid[i][i] == symbol
    end

    right_to_left = (0...grid.length).all? do |i|
      j = grid.length - 1 - i
      grid[i][j] == symbol
    end

    left_to_right || right_to_left
  end

  def fill(symbol)
    grid.each_index do |i|
      grid.each_index do |j|
        grid[i][j] = symbol if i == 2
      end
    end
  end
end
