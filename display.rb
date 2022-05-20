# frozen_string_literal: true

# Text display functions for Tic-Tac-Toe
module Display
  def display_grid
    num_total_length = (grid.length**2).digits.count
    grid.map do |row|
      row.map do |cell|
        cell.to_s.rjust(num_total_length)
      end
    end
  end

  def display_grid_decorations
    display = display_grid
    dash = '-' * (display[0][0].length + 2)
    dash_plus = "#{dash}+" * (display.length - 1)
    "\e[36m#{dash_plus}#{dash}\e[0m"
  end

  def prompt
    print '> '
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
    count_range = (3..0)
    count_range.first.downto(count_range.last).each do |i|
      system('clear')
      puts "#{game_starting}\n\n#{game_message} #{i}" unless i.zero?
      sleep(0.8)
      system('clear')
    end
  end

  def display_board_size_prompt
    puts 'Enter the grid size for your game (between 3 to 10):'
    prompt
  end

  def display_board_size_error
    system('clear')
    puts 'Invalid board size! Enter the grid size for your game (between 3 to 10):'
    prompt
  end

  def display_total_player_prompt
    system('clear')
    puts 'Enter how many players in the game (two or more players required):'
    prompt
  end

  def display_total_player_error
    system('clear')
    puts 'Invalid number of players! Enter how many players in the game (two or more players required):'
    prompt
  end

  def display_create_name_prompt(player_num)
    system('clear')
    puts "Player ##{player_num}, enter your name:"
    prompt
  end

  def display_create_name_error(player_num, name)
    system('clear')
    puts "Player ##{player_num}, #{name} is taken. Enter your name:"
    prompt
  end

  def display_create_symbol_prompt(name)
    system('clear')
    puts "#{name}, enter a single symbol as your token (no numbers):"
    prompt
  end

  def display_create_symbol_error(name, symbol)
    system('clear')
    puts "#{name}, '#{symbol}' is not available or taken"
    puts 'Enter a single symbol as your token (no numbers):'
    prompt
  end

  def display_play_turn_prompt(player)
    board.show
    puts "#{player.name}, enter a number to place '#{player.symbol}' in an available spot:"
    prompt
  end

  def display_player_turn_error(player)
    board.show
    puts "Sorry #{player.name} (#{player.symbol}), invalid spot. Try again:"
    prompt
  end

  def display_winner
    puts "\e[1mGAME OVER!\e[22m #{current_player.name} is the winner!\n\n"
  end

  def display_tie
    "\e[1mDRAW GAME!\e[22m\n\n"
  end
end
