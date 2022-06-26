# frozen_string_literal: true

require_relative 'color'

# Message prompts and errors
module Messages
  def prompt
    "\n> "
  end

  # prompts
  def prompt_board_size
    print "Enter the grid size for your game (between 3 to 10):#{prompt}"
  end

  def prompt_total_player
    system('clear')
    print "Enter how many players in the game (2 to 8 players):#{prompt}"
  end

  def prompt_no_scpu(player_num)
    system('clear')
    print "Player ##{player_num}, are you a (h)uman or (c)omputer?#{prompt}"
  end

  def prompt_player_type(player_num)
    system('clear')
    print "Player ##{player_num}, are you a (h)uman, (c)omputer, or (s)uper computer?#{prompt}"
  end

  def prompt_create_name(player_num)
    system('clear')
    print "Player ##{player_num}, enter your name:#{prompt}"
  end

  def prompt_create_symbol(name)
    system('clear')
    print "#{name}, enter a single symbol as your token (no numbers):#{prompt}"
  end

  def prompt_get_position(player)
    print "#{player.name}, enter a number to place '#{player.symbol}' in an available spot:#{prompt}"
  end

  # errors
  def error_board_size
    system('clear')
    print "Invalid board size! Enter the grid size for your game (between 3 to 10):#{prompt}"
  end

  def error_total_player
    system('clear')
    print "Invalid number of players! Enter how many players in the game (2 to 8 players):#{prompt}"
  end

  def error_create_name(player_num, name)
    system('clear')
    print "Player ##{player_num}, #{name} is taken. Enter your name:#{prompt}"
  end

  def error_create_symbol(name, symbol)
    system('clear')
    puts "#{name}, '#{symbol}' is not available or taken"
    print "Enter a single symbol as your token (no numbers):#{prompt}"
  end

  def error_get_position(player)
    print "Sorry #{player.name} (#{player.symbol}), invalid spot. Try again:#{prompt}"
  end

  # cpu messages
  def cpu_prompt_creation(player_num, cpu)
    system('clear')
    puts "Computer ##{player_num} has chosen name and symbol: #{cpu.name} #{cpu.symbol}"
    sleep(2)
  end

  def cpu_prompt_thinking(name, symbol)
    puts "#{name} (#{symbol}) is thinking..."
    sleep(0.75)
  end

  def cpu_prompt_random_move(cpu, position_num)
    puts "#{cpu.name} (#{cpu.symbol}) chose position '#{position_num}'"
    sleep(1.25)
  end

  def cpu_prompt_block(cpu, position_num)
    puts "#{cpu.name} (#{cpu.symbol}) initiates block protocol on position '#{position_num}'"
    sleep(1.25)
  end

  def cpu_prompt_win(cpu, position_num)
    puts "#{cpu.name} (#{cpu.symbol}) initiates win protocol on position '#{position_num}'"
    sleep(1.25)
  end

  # game over
  def message_winner
    puts "GAME OVER! #{current_player.name} is the winner!".bold + "\n\n"
  end

  def message_tie
    puts "DRAW GAME!".bold + "\n\n"
  end

  def message_repeat_game?
    print "Play another game? (y)es/(n)o:#{prompt}"
  end

  def message_thanks
    puts "Thanks for Playing!".bold
  end

  def message_play_with_original_players?
    print "Play with original players? (y)es/(n)o:#{prompt}"
  end
end
