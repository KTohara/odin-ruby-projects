# frozen_string_literal: true

require 'byebug'

class Board
  def initialize(num)
    @grid = Array.new(num) { [''] * num }
    @grid_spaces = num
  end

  def create_board
    num = 0
    @grid.each do |row|
      row.map! { num += 1 }
    end
  end

  def grid_to_display
    num_total_length = (@grid_spaces**2).digits.count
    @grid.each do |row|
      row.map! do |cell|
        cell.to_s.rjust(num_total_length)
      end
    end
  end

  def display_board
    system('clear')
    display = grid_to_display
    dash = '-' * (display[0][0].length + 2)
    dash_plus = "#{dash}+" * (display.length - 1)
    total_divider = "#{dash_plus}#{dash}"
    display.each.with_index do |row, i|
      num_row = " #{row.join(' | ')} "
      puts num_row
      puts total_divider unless i == display.length - 1
    end
  end

  def place_mark(num, symbol)
    @grid.each_index do |i|
      @grid.each_index do |j|
        @grid[i][j] = symbol if @grid[i][j].to_i == num
      end
    end
  end

  def valid_move?(num)
    @grid.flatten[(num - 1)] == num
  end

  def full_board?(symbols)
    board_array = @grid.flatten
    board_array.all? { |cell| symbols.include?(cell) }
  end

  def fill
    @grid.each_index do |i|
      @grid.each_index do |j|
        @grid[i][j] = '@' if j == 2
      end
    end
  end

  def win_row?(symbol)
    @grid.any? do |row|
      row.all? { |cell| cell == symbol }
    end
  end

  def win_col?(symbol)
    col = Array.new(@grid_spaces) { [] * @grid_spaces }
    @grid.each_index do |i|
      @grid.each_index do |j|
        col[i][j] = @grid[j][i]
      end
    end
    col.any? do |row|
      row.all? { |cell| cell == symbol }
    end
  end
end

board = Board.new(5)
board.create_board
board.place_mark(2, '@')
board.display_board
board.fill
board.display_board
p board.win_row?('@')
p board.win_col?('@')