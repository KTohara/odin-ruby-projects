require 'byebug'

class Board
  def initialize(num)
    @grid = Array.new(num) { [''] * num }
    @grid_spaces = num.to_i
    @grid_num_total_length = (@grid_spaces ** 2).digits.count
  end

  def create_board
    num = 1
    @grid.each do |row|
      row.map! do |space|
        num_length = num.digits.count
        space = " " * (@grid_num_total_length - num_length) + num.to_s
        num += 1
        space
      end
    end
  end

  def display_board
    system("clear")
    (0...@grid.length).each.with_index do |row, i|
      spaces = "-" * (@grid[row][i].length + 2)
      num_row = " #{@grid[row].join(" | ")} "
      divider = "#{(spaces + "+") * (@grid.length - 1)}#{spaces}" unless row == @grid.length - 1
      puts num_row
      puts divider
    end
  end

  def pos=(num)
    
  end
end

board = Board.new(5)
board.create_board
board.display_board