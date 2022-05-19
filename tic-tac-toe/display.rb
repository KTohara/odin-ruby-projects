module Display
  def display_grid(grid_length)
    num_total_length = (grid_length**2).digits.count
    grid.map do |row|
      row.map do |cell|
        cell.to_s.rjust(num_total_length)
      end
    end
  end

  def display_grid_decorations
    display = display_grid(grid_length)
    dash = '-' * (display[0][0].length + 2)
    dash_plus = "#{dash}+" * (display.length - 1)
    "#{dash_plus}#{dash}"
  end

  def prompt
    print '> '
  end

  def display_intro
    puts "Let's Play Tic-Tac-Toe! \n\n"
  end

  def display_lets_play
    game_starting = "\e[1mGAME IS READY\e[22m"
    game_message = "Game Starting ..."
    count_range = (3..0)
    count_range.first.downto(count_range.last).each do |i|
      system('clear')
      puts "#{game_starting}\n\n#{game_message} #{i}" unless i == 0
      sleep(0.8)
      system('clear')
    end
  end

  def display_board_size_prompt
    puts 'Enter the grid size for your game:'
    prompt
  end

  def display_board_size_error
    system('clear')
    puts "Number not entered! Enter the grid size for your game:"
    prompt
  end

  def display_total_player_prompt
    puts 'Enter how many players in the game:'
    prompt
  end

  def display_total_player_error
    board.show
    puts 'Number not entered! Enter how many players in the game:'
    prompt
  end

  def display_create_player_prompt(player_num)
    puts "Player ##{player_num}, enter your name:"
    prompt
  end

  def display_create_symbol_prompt(name)
    puts "#{name}, enter a non-number as a symbol you'd like as your token:"
    prompt
  end

  def display_create_symbol_error(name, symbol)
    board.show
    puts "#{name}, '#{symbol}' is not available, or taken"
    puts "Enter a non-number symbol you'd like as your token:"
    prompt
  end

  def display_player_turn_prompt(player)
    puts "#{player.name}, enter a number to place '#{player.symbol}' in an available spot:"
    prompt
  end

  def display_player_turn_error(player)
    board.show
    puts "Sorry #{player.name}, invalid spot. Try again:"
    prompt
  end

  def display_winner
    puts "\e[1mGAME OVER!\e[22m #{current_player.name} is the winner!"
  end

  def display_tie
    "\e[1mDRAW GAME!\e[22m"
  end
end