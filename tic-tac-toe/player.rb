# frozen_string_literal: true

# Player Class - Requires two instances for a game
class Player
  attr_reader :name, :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end
end