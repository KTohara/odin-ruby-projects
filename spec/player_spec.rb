# frozen_string_literal: true

require 'player'

describe Player do
  subject(:player) { described_class.new('Rhubarb', 'x') }
  let(:board) { instance_double(Board) }
  let(:symbols) { %w[x o] }

  before { allow($stdout).to receive(:write) }

  describe '#get_position' do
    context 'when input is valid' do
      let(:valid_input) { '3' }

      before { allow(board).to receive(:valid_move?).and_return(true) }

      it 'should return a position based on user input' do
        expect(player).to receive(:gets).and_return(valid_input)
        player.get_position(board, symbols)
      end
    end

    context 'when input is invalid once, then valid' do
      let(:invalid_inputs) { ['100', 'x', '14', '!@#$'] }
      let(:valid_input) { '5' }

      before do
        allow(board).to receive(:valid_move?).and_return(false, false, false, false, true)
        invalid_inputs.each { |input| expect(player).to receive(:gets).and_return(input) }
      end

      it 'calls error_get_position once' do
        expect(player).to receive(:gets).and_return(valid_input)
        player.get_position(board, symbols)
      end
    end
  end
end

describe Computer do
  subject(:cpu) { described_class.new('R2D2', '%') }
  let(:symbols) { ['@', '%'] }

  before do
    allow($stdout).to receive(:write)
    allow(cpu).to receive(:sleep)
  end

  describe '#win_move' do
    context 'when there is a winning move' do
      let(:board) { instance_double(Board, grid: [[1, 2, 3], [4, 5, '%'], [7, 8, '%']]) }

      it 'should return a position as a number' do
        dupe = instance_double('Board', grid: [[1, 2, 3], [4, 5, '%'], [7, 8, '%']])
        allow(board).to receive(:dup).and_return(dupe)
        allow(dupe).to receive(:valid_move?).and_return(true, true, true)
        allow(dupe).to receive(:place_symbol)
        allow(dupe).to receive(:winner).and_return(nil, nil, cpu.symbol)
        expect(cpu.win_move(board)).to eq(3)
      end
    end

    context 'when there is no winning move' do
      let(:board) { instance_double(Board, grid: [[1, '@', '@'], [4, '@', '%'], [7, '@', '%']]) }

      it 'returns nil' do
        dupe = instance_double('Board', grid: [[1, '@', '@'], [4, '@', '%'], [7, '@', '%']])
        allow(board).to receive(:dup).and_return(dupe)
        allow(dupe).to receive(:valid_move?).and_return(true, true, true)
        allow(dupe).to receive(:place_symbol)
        allow(dupe).to receive(:winner).and_return(nil, nil, nil)
        expect(cpu.win_move(board)).to be_nil
      end
    end
  end

  describe '#block_move' do
    let(:symbols) { ['@', '%'] }
    let(:opponent_symbol) { '@' }

    context 'when a blocking move is available' do
      let(:board) { instance_double(Board, grid: [[1, '@', '@'], ['%', 5, 6], [7, '%', 9]]) }
      let(:opponent_symbol) { '@' }

      it 'returns a position as a number' do
        dupe = instance_double(Board, grid: [[1, '@', '@'], ['%', 5, 6], [7, '%', 9]])

        allow(board).to receive(:dup).and_return(dupe)
        allow(dupe).to receive(:valid_move?).and_return(true)
        allow(dupe).to receive(:place_symbol)
        allow(dupe).to receive(:winner).and_return(opponent_symbol)
        expect(cpu.block_move(board, symbols)).to eq(1)
      end
    end

    context 'when there is no blocking move' do
      let(:board) { instance_double(Board, grid: [['@', 2, '%'], ['%', '@', '@'], ['@', '%', '%']]) }

      it 'returns nil' do
        dupe = instance_double(Board, grid: [['@', 2, '%'], ['%', '@', '@'], ['@', '%', '%']])

        allow(board).to receive(:dup).and_return(dupe)
        allow(dupe).to receive(:valid_move?).and_return(true)
        allow(dupe).to receive(:place_symbol)
        allow(dupe).to receive(:winner).and_return(nil)
        expect(cpu.block_move(board, symbols)).to be_nil
      end
    end
  end

  describe '#random_move' do
    let(:board) { instance_double(Board, grid: [[1, 2, 3], [4, 5, 6], [7, 8, 9]]) }

    it 'returns a number on the board' do
      allow(board).to receive(:valid_pos).and_return((1..9).to_a)
      expect(cpu.random_move(board)).to be_between(1, 9)
    end

    context 'when a board space has been taken' do
      let(:board) { instance_double(Board, grid: [[1, 2, 3], [4, 5, 6], [7, 8, '@']]) }

      it 'does not return an occupied space' do
        allow(board).to receive(:valid_pos).and_return((1..8).to_a)
        expect(cpu.random_move(board)).to_not eq(9)
      end
    end
  end

  describe '#get_position' do
    let(:symbols) { ['@', '%'] }

    context 'when a winning, blocking, or random move is available' do
      let(:board) { instance_double(Board, grid: [[1, 2, 3], [4, '%', '@'], [7, '%', '@']]) }

      it 'will return a winning move' do
        expect(cpu).to_not receive(:block_move)
        expect(cpu).to_not receive(:random_move)
        expect(cpu).to receive(:win_move).and_return(3)
        cpu.get_position(board, symbols)
      end
    end

    context 'when a blocking or random move is available' do
      let(:board) { instance_double(Board, grid: [[1, 2, 3], [4, '%', 6], [7, '%', '@']]) }

      it 'will return a blocking move' do
        allow(cpu).to receive(:win_move).and_return(nil)
        expect(cpu).to_not receive(:random_move)
        expect(cpu).to receive(:block_move).and_return(2)
        cpu.get_position(board, symbols)
      end
    end

    context 'when neither a win or block can be found' do
      let(:board) { instance_double(Board, grid: [[1, 2, 3], [4, 5, 6], [7, 8, 9]]) }

      it 'will return a random move' do
        expect(cpu).to receive(:win_move).and_return(nil)
        expect(cpu).to receive(:block_move).and_return(nil)
        expect(cpu).to receive(:random_move)
        cpu.get_position(board, symbols)
      end
    end
  end
end
