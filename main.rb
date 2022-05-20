# frozen_string_literal: true

require_relative 'board'
require_relative 'player'
require_relative 'game'
require_relative 'display'

def play_game
  game = Game.new
  game.play
  repeat_game
end

def repeat_game
  puts "Play another game? Enter 'y' to start a new game"
  input = gets.chomp.downcase
  if input == 'y'
    play_game
  else
    puts "\e[1mThanks for Playing!\e[22m"
  end
end

play_game
