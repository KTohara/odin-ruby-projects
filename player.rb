# frozen_string_literal: true

require_relative 'display'

# Player Class - Requires two instances for a game
class Player
  include Display
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
    display_create_name_prompt(player_num)
    input = gets.chomp
    while taken.include?(input) && taken.any?
      display_create_name_error(player_num, input)
      input = gets.chomp
    end
    taken << input
    @name = input
  end

  def create_symbol(name, taken)
    display_create_symbol_prompt(name)
    input = gets.chomp
    until input.match?(/^[^\d]$/) && !taken.include?(input)
      display_create_symbol_error(name, input)
      input = gets.chomp
    end
    taken << input
    @symbol = input
  end
end
