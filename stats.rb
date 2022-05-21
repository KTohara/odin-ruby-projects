# frozen_string_literal: true

# Win tracker for players
class Stats
  attr_accessor :wins

  def initialize
    @wins = {}
  end

  def create_stats(players)
    players.each_with_object(wins) { |player, hash| hash[player.name] = 0 }
  end

  def add_win(current_player)
    wins[current_player.name] += 1
  end
end
