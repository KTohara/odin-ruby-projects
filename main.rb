# frozen_string_literal: true

require_relative 'game'

def play_game(replay = nil, game = nil)
  replay ||= false
  game ||= Game.new
  game.play(replay)
  repeat_game(game)
end

def repeat_game(game)
  print "Play another game? (y)es/(n)o \n> "
  input = gets.chomp.downcase
  if input == 'y'
    print "Play with original players? (y)es/(n)o \n> "
    input = gets.chomp.downcase
    case input
    when 'y'
      play_game(true, game)
    when 'n'
      play_game
    else
      repeat_game
    end
  else
    puts "\e[1mThanks for Playing!\e[22m"
    sleep(2)
    exit 0
  end
end

play_game
