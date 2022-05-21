# frozen_string_literal: true

require_relative 'display'
require_relative 'messages'

# Player Class - Requires two instances for a game
class Player
  include Display
  include Messages
  attr_reader :player_num, :name, :symbol

  def initialize(player_num, taken)
    @player_num = player_num
    @name = nil
    @symbol = nil
    create_player(player_num, taken)
  end

  def create_player(player_num, taken)
    create_name(player_num, taken)
    create_symbol(name, taken)
  end

  def create_name(player_num, taken)
    prompt_create_name(player_num)
    input = gets.chomp
    while taken.include?(input) && taken.any?
      error_create_name(player_num, input)
      input = gets.chomp
    end
    taken << input
    @name = input
  end

  def create_symbol(name, taken)
    prompt_create_symbol(name)
    input = gets.chomp
    until input.match?(/^[^\d]$/) && !taken.include?(input)
      error_create_symbol(name, input)
      input = gets.chomp
    end
    taken << input
    @symbol = input
  end
end
