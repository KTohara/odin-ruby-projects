# frozen_string_literal: true

# rubocop: disable Metrics/BlockLength, Style/WordArray, Layout/FirstArrayElementIndentation

require 'board'

describe Board do
  subject(:board) { described_class.new(3) }
  let(:grid) { board.grid }

  describe '#initialize' do
    let(:large_board) { described_class.new(6) }
    let(:large_grid) { large_board.grid }

    it 'should set @grid to a 2D array with n rows and n columns' do
      expect(grid.length).to eq(3)
      expect(grid[0].length).to eq(3)

      expect(large_grid.length).to eq(6)
      expect(large_grid[0].length).to eq(6)
    end

    it 'should set all elements of @grid to an empty space' do
      empty_grid = Array.new(3) { Array.new(3, '') }
      expect(grid).to eq(empty_grid)
    end
  end

  describe '#create_board' do
    it 'should change all elements inside the nested array into consecutive numbers' do
      board.create_board
      expect(grid.flatten).to eq((1..9).to_a)
    end

    it 'should not change the length of the original board' do
      length = board.grid.flatten.length
      expect { board.create_board }.to_not change { length }
    end
  end

  describe '#place_symbol' do
    before { board.create_board }
    let(:player_symbol) { '@' }
    let(:input_num) { 6 }

    context 'when space is empty' do
      it 'should set a symbol on the board' do
        board.place_symbol(input_num, player_symbol)
        expect(grid).to eq([
          [1, 2, 3],
          [4, 5, '@'],
          [7, 8, 9]
        ])
      end
    end

    context 'when space is taken' do
      it 'should not place multiple symbols' do
        board.place_symbol(input_num, player_symbol)
        expect(grid).to_not eq([
          [1, 2, '@'],
          [4, 5, '@'],
          [7, 8, '@']
        ])
      end
    end
  end

  describe '#valid_move?' do
    before do
      board.instance_variable_set(:@grid, [
        ['#', 2, 3],
        [4, '#', '@'],
        [7, 8, '@']
      ])
    end

    it 'returns true if number given exists on the board' do
      move_pos = 3
      expect(board.valid_move?(move_pos)).to be true
    end

    it 'returns false if number given does not exist on the grid' do
      move_pos = 1
      expect(board.valid_move?(move_pos)).to be false
    end
  end

  describe '#over?' do
    context 'when the game is won' do
      it 'calls on #won?' do
        expect(board).to receive(:won?).at_least(:once)
        board.over?
      end
    end

    context 'when the game is tied' do
      it 'calls on #tied?' do
        board.instance_variable_set(:@grid, [
          ['o', 'x', 'o'],
          ['o', 'x', 'x'],
          ['x', 'o', 'x']
        ])
        expect(board).to receive(:tied?).at_least(:once)
        board.over?
      end
    end
  end

  describe '#tied?' do
    it 'returns true if there is no winner' do
      board.instance_variable_set(:@grid, [
        ['o', 'x', 'o'],
        ['o', 'x', 'x'],
        ['x', 'o', 'x']
      ])
      expect(board.tied?).to be true
    end

    it 'returns false if there is a winner' do
      board.instance_variable_set(:@grid, [
        ['#', '@', '@'],
        ['@', '#', '@'],
        ['#', '@', '@']
      ])
      expect(board.tied?).to be false
    end
  end

  describe '#won?' do
    it 'should return false when winner is nil' do
      allow(board).to receive(:winner).at_least(:once).and_return(nil)
      expect(board.won?).to be false
    end

    it 'should return true when there is a winner' do
      allow(board).to receive(:winner).at_least(:once).and_return(true)
      expect(board.won?).to be true
    end
  end

  describe '#winner' do
    context 'when there is a vertical 3-in-a-row' do
      it 'returns the winner' do
        board.instance_variable_set(:@grid, [
          [1, 2, '@'],
          [4, 5, '@'],
          [7, 8, '@']
        ])
        expect(board.winner).to eq('@')
      end
    end

    context 'when there is a horizontal 3-in-a-row' do
      it 'returns the winner' do
        board.instance_variable_set(:@grid, [
          ['x', 'x', 'x'],
          [4, 5, 6],
          [7, 8, 9]
        ])
        expect(board.winner).to eq('x')
      end
    end

    context 'when there is a diagonal 3-in-a-row' do
      it 'returns the winner' do
        board.instance_variable_set(:@grid, [
          ['o', 2, 'x'],
          [4, 'o', 'x'],
          [7, 'x', 'o']
        ])
        expect(board.winner).to eq('o')
      end
    end

    context 'when game has not been played' do
      it 'returns nil' do
        board.create_board
        expect(board.winner).to be_nil
      end
    end

    context 'when there is no winner' do
      it 'returns nil' do
        board.instance_variable_set(:@grid, [
          ['o', 'x', 'o'],
          ['o', 'x', 'x'],
          ['x', 'o', 'x']
        ])
        expect(board.winner).to be_nil
      end
    end
  end
end

# rubocop: enable Metrics/BlockLength, Style/WordArray, Layout/FirstArrayElementIndentation
