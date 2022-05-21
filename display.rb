# frozen_string_literal: true
require 'byebug'
# Text display functions for Tic-Tac-Toe
module Display
  def display_grid_array
    max_length = (board.grid.length ** 2).digits.count
    grid = board.grid.map do |row|
      row.map { |num| num.to_s.rjust(max_length) }
    end
    lines = (0...grid.length).inject("") { |acc, i| i == grid.length - 1 ? acc + "#{"-" * (max_length + 2)}" : acc + "#{"-" * (max_length + 2)}+" }
    lines = "\e[36m#{lines}\e[0m"
    grid.each_with_index.inject([]) do |acc, (row, i)|
      nums = " #{row.join(" \e[36m|\e[0m ")} "
      acc << "#{' ' * 4}#{nums}"
      acc << "#{' ' * 4}#{lines}" unless i == grid.length - 1
      acc
    end
  end

  def display_banner
    puts "\e[36m █████     ███               █████                           █████                      \e[0m"
    puts "\e[36m ░░███     ░░░               ░░███                           ░░███                      \e[0m"
    puts "\e[36m ███████   ████   ██████     ███████    ██████    ██████     ███████    ██████   ██████ \e[0m"
    puts "\e[36m░░░███░   ░░███  ███░░███   ░░░███░    ░░░░░███  ███░░███   ░░░███░    ███░░███ ███░░███\e[0m"
    puts "\e[36m  ░███     ░███ ░███ ░░░      ░███      ███████ ░███ ░░░      ░███    ░███ ░███░███████ \e[0m"
    puts "\e[36m  ░███ ███ ░███ ░███  ███     ░███ ███ ███░░███ ░███  ███     ░███ ███░███ ░███░███░░░  \e[0m"
    puts "\e[36m  ░░█████  █████░░██████      ░░█████ ░░████████░░██████      ░░█████ ░░██████ ░░██████ \e[0m"
    puts "\e[36m   ░░░░░  ░░░░░  ░░░░░░        ░░░░░   ░░░░░░░░  ░░░░░░        ░░░░░   ░░░░░░   ░░░░░░  \e[0m"
    puts
  end

  def display_lets_play
    game_starting = "\e[1mGAME STARTING\e[22m"
    game_message = 'Initializing ...'
    3.downto(1).each do |i|
      system('clear')
      puts "#{game_starting}\n\n#{game_message} #{i}" unless i.zero?
      sleep(0.8)
      system('clear')
    end
  end

  def stats_display_length
    stats.wins.map { |k, v| k.length + v.to_s.length }.max + 6
  end

  def display_score_array
    score_top = "+#{"=- SCORE -=".center(stats_display_length, '-')}+"
    score_bottom = "+#{'-' * (score_top.length - 2)}+"
    stats.wins.each_with_index.inject([]) do |acc, ((player, score), i)|
      spaces = score_top.length - player.length - score.digits.count - 6
      acc << score_top if i == 0
      acc << "|  #{player}: #{score}#{" " * spaces}|"
      acc << score_bottom if i == stats.wins.length - 1
      acc
    end
  end

  def show_board
    system('clear')
    display_banner
    scores = display_score_array
    grid = display_grid_array
    scores << " " * scores.first.length while scores.length < grid.length
    display_array = scores.zip(grid)
    display_array.each { |line| puts line.join }
    puts
  end

  def prompt
    "\n> "
  end

  def display_board_size_prompt
    print "Enter the grid size for your game (between 3 to 10):#{prompt}"
  end

  def display_board_size_error
    system('clear')
    print "Invalid board size! Enter the grid size for your game (between 3 to 10):#{prompt}"
  end

  def display_total_player_prompt
    system('clear')
    print "Enter how many players in the game (two or more players required):#{prompt}"
  end

  def display_total_player_error
    system('clear')
    print "Invalid number of players! Enter how many players in the game (two or more players required):#{prompt}"
  end

  def display_create_name_prompt(player_num)
    system('clear')
    print "Player ##{player_num}, enter your name:#{prompt}"
  end

  def display_create_name_error(player_num, name)
    system('clear')
    print "Player ##{player_num}, #{name} is taken. Enter your name:#{prompt}"
  end

  def display_create_symbol_prompt(name)
    system('clear')
    print "#{name}, enter a single symbol as your token (no numbers):#{prompt}"
  end

  def display_create_symbol_error(name, symbol)
    system('clear')
    puts "#{name}, '#{symbol}' is not available or taken"
    print "Enter a single symbol as your token (no numbers):#{prompt}"
  end

  def display_play_turn_prompt(player, board)
    show_board
    print "#{player.name}, enter a number to place '#{player.symbol}' in an available spot:#{prompt}"
  end

  def display_player_turn_error(player, board)
    show_board
    print "Sorry #{player.name} (#{player.symbol}), invalid spot. Try again:#{prompt}"
  end

  def display_winner
    puts "\e[1mGAME OVER!\e[22m #{current_player.name} is the winner!\n\n"
  end

  def display_tie
    "\e[1mDRAW GAME!\e[22m\n\n"
  end
end