# frozen_string_literal: true

# Display functions
module Display
  def display_grid_array
    max_length = (board.grid.length**2).digits.count
    grid = board.grid.map do |row|
      row.map { |num| num.to_s.rjust(max_length) }
    end
    lines = (0...grid.length).inject('') do |acc, i|
      i == grid.length - 1 ? acc + ('-' * (max_length + 2)).to_s : acc + "#{'-' * (max_length + 2)}+"
    end
    lines = "\e[36m#{lines}\e[0m"
    grid.each_with_object([]).with_index do |(row, acc), i|
      nums = " #{row.join(" \e[36m|\e[0m ")} "
      acc << "#{' ' * 4}#{nums}"
      acc << "#{' ' * 4}#{lines}" unless i == grid.length - 1
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
      puts "\e[1mLets Play...\e[22m\n\n".center(95)
      display_banner
      puts "\n\n#{game_starting}\n\n#{game_message} #{i}" unless i.zero?
      sleep(1)
      system('clear')
    end
  end

  def stats_display_length
    players.map { |player| player.name.length + player.wins.to_s.length + player.symbol.length }.max + 7
  end

  def display_score_array
    score_top = "+#{'=- SCORE -='.center(stats_display_length, '-')}+"
    score_bottom = "+#{'-' * (score_top.length - 2)}+"
    players.each_with_object([]).with_index do |(player, acc), i|
      spaces = score_top.length - player.name.length - player.wins.digits.count - 8 
      acc << score_top if i.zero?
      acc << "|  #{player.symbol} #{player.name}: #{player.wins}#{' ' * spaces}|"
      acc << score_bottom if i == players.length - 1
    end
  end

  def display_board
    system('clear')
    display_banner
    scores = display_score_array
    grid = display_grid_array
    scores << ' ' * scores.first.length while scores.length < grid.length
    display_array = scores.zip(grid)
    display_array.each { |line| puts line.join }
    puts
  end
end
