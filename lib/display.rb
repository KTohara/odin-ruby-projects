# frozen_string_literal: true

require_relative 'color'

# Display functions
module Display
  TOP_L  = "\u256D".cyan # ╭
  TOP_R  = "\u256E".cyan # ╮
  BOT_L  = "\u2570".cyan # ╰
  BOT_R  = "\u256F".cyan # ╯
  HORI   = "\u2500".cyan # ─
  VERT   = "\u2502".cyan # │
  JOIN = "\u253C".cyan # ┼

  # displays when game start
  def display_lets_play
    game_starting = 'GAME STARTING'.bold
    game_message = 'Initializing ...'
    3.downto(1).each do |i|
      system('clear')
      puts "Lets Play...\n\n".center(95).bold
      display_banner
      puts "\n\n#{game_starting}\n\n#{game_message} #{i}" unless i.zero?
      sleep(0.75)
      system('clear')
    end
  end

  # main board rendering method
  def display_board(game)
    system('clear')
    display_banner
    board_array(game).each { |line| puts line.join }
    puts
  end

  def display_banner
    puts '
 █████     ███               █████                           █████
 ░░███     ░░░               ░░███                           ░░███
 ███████   ████   ██████     ███████    ██████    ██████     ███████    ██████   ██████
░░░███░   ░░███  ███░░███   ░░░███░    ░░░░░███  ███░░███   ░░░███░    ███░░███ ███░░███
  ░███     ░███ ░███ ░░░      ░███      ███████ ░███ ░░░      ░███    ░███ ░███░███████
  ░███ ███ ░███ ░███  ███     ░███ ███ ███░░███ ░███  ███     ░███ ███░███ ░███░███░░░
  ░░█████  █████░░██████      ░░█████ ░░████████░░██████      ░░█████ ░░██████ ░░██████
   ░░░░░  ░░░░░  ░░░░░░        ░░░░░   ░░░░░░░░  ░░░░░░        ░░░░░   ░░░░░░   ░░░░░░
    '.cyan
  end

  # joined board and score array
  def board_array(game)
    scores = [score_top] + score_array(game.players) + [score_bottom]
    grid = grid_array(game.board)
    spaces = ' ' * (stats_length(players) + 4)
    scores << spaces while scores.length < grid.length
    scores.zip(grid)
  end

  # score methods
  def score_top
    len = (stats_length(players) / 2) - 3
    if stats_length(players).even?
      "#{TOP_L}#{HORI * len} SCORES #{HORI * len}#{TOP_R}"
    else
      "#{TOP_L}#{HORI * len} SCORES #{HORI * (len + 1)}#{TOP_R}"
    end
  end

  def score_bottom
    len = (stats_length(players) + 2)
    BOT_L + HORI * len + BOT_R
  end

  def stats_length(players)
    players.map { |player| player.name.length + player.wins.to_s.length + player.symbol.length }.max + 5
  end

  def score_array(players)
    players.map do |player|
      spaces = ' ' * (stats_length(players) - player.name.length - player.wins.digits.count - 5)
      "#{VERT}  #{player.symbol} #{player.name}:#{spaces}#{player.wins}  #{VERT}"
    end
  end

  # board/grid methods
  def grid_array(board)
    rows(board).each_with_object([]).with_index do |(row, acc), i|
      cells = " #{row.join(" #{VERT} ")} "
      acc << cell_space(cells)
      acc << cell_space(div_row(board).cyan) unless i == board.grid.length - 1
    end
  end

  def rows(board)
    board.grid.map do |row|
      row.map { |num| num.to_s.rjust(max_len(board)) }
    end
  end

  def max_len(board)
    (board.grid.length**2).digits.count
  end

  def cell_space(obj)
    "#{' ' * 4}#{obj}"
  end

  def div_row(board)
    len = max_len(board) + 2
    (HORI * len + JOIN) * (board.grid.length - 1) + HORI * len
  end
end
