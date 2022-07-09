# frozen_string_literal: true

require 'game'

describe Game do
  let(:p1) { instance_double(Player, 'p1', name: 'one', symbol: 'x') }
  let(:p2) { instance_double(Player, 'p2', name: 'two', symbol: 'o') }
  let(:board_size) { 3 }
  subject(:game) { described_class.new(board_size, [p1, p2]) }

  before do
    allow($stdout).to receive(:write)
    allow(game).to receive(:sleep)
    allow(game).to receive(:system)
  end

  describe '#initalize' do
    it 'should set take the players arg, and set @symbols as an array of total symbols' do
      expect(game.symbols).to eq(%w[x o])
    end

    it 'should set @current_player as the first player in the players array' do
      expect(game.current_player).to eq(p1)
    end
  end

  describe '#play_turns' do
    before do
      allow(game.current_player).to receive(:get_position)
      allow(game.board).to receive(:place_symbol)
      allow(game).to receive(:display_board)
      # allow(game.board).to receive(:over?).and_return(true)
    end

    it 'sends #get_position to current_player' do
      expect(game.current_player).to receive(:get_position).once
      game.play_turns
    end

    it 'sends #place_symbol to the board' do
      expect(game.board).to receive(:place_symbol).once
      game.play_turns
    end

    context 'if game is over' do
      before do
        allow(p1).to receive(:get_position)
        allow(p2).to receive(:get_position)
        allow(game.board).to receive(:place_symbol)
        allow(game).to receive(:display_board)
        allow(game.board).to receive(:over?).and_return(false, true)
      end

      it 'breaks the loop' do
        expect(game.board).to receive(:over?).twice
        game.play_turns
      end
    end
  end

  describe '#game_turns' do
    before do
      allow(game).to receive(:display_board)
    end

    context 'if the game is won' do
      before { allow(game.board).to receive(:won?).and_return(true) }

      it 'calls #add_win with the current player' do
        expect(game).to receive(:add_win).with(game.current_player)
        game.game_over
      end
    end

    context 'if the game is not won' do
      before { allow(game.board).to receive(:won?).and_return(false) }

      it 'does not call #add_win' do
        expect(game).to_not receive(:add_win)
      end
    end
  end
end
