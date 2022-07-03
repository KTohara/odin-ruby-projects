# frozen_string_literal: true

require 'player'
# require 'board'

describe Player do
  subject(:player) { Player.new('Rhubarb', 'x') }
  let(:board) { instance_double(Board) }
  let(:symbols) { double('symbols') }

  describe '#get_position' do
    before do
      valid_input = '3'
      allow(player).to receive(:prompt_get_position)
      allow(player).to receive(:gets).and_return(valid_input)
      allow(board).to receive(:valid_move?).and_return(true)
    end

    it 'should return a position based on user input' do
      expect(player.get_position(board, symbols)).to eq(3)
      player.get_position(board, symbols)
    end
  end
end
