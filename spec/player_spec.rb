# frozen_string_literal: true

require 'player'
require 'board'

describe Player do
  subject(:player) { Player.new('Rhubarb', 'x') }
  let(:board) { instance_double(Board) }
  # before do
  #   player.instance_variable_set(:@name, 'John')
  #   player.instance_variable_set(:@symbol, '@')
  # end

  describe '#get_position' do
    before do
      allow(board).to receive(:valid_move?).and_return true
    end

    it 'should return a position based on user input' do

    end
  end
end
