# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/board'

describe ConnectFour do # rubocop:disable Metrics/BlockLength
  subject(:game) { described_class.new }

  describe 'when initialized' do
    it 'has player1 instance variable with a Player object value' do
      player1 = game.instance_variable_get(:@player1)
      expect(player1).to be_a(Player)
    end

    it 'has player2 instance variable with a player object value' do
      player2 = game.instance_variable_get(:@player2)
      expect(player2).to be_a(Player)
    end

    it 'has a board instance variable with a board object value' do
      board = game.instance_variable_get(:@board)
      expect(board).to be_a(Board)
    end
  end

  describe '#valid_input?' do # rubocop:disable Metrics/BlockLength
    context 'if the input is valid' do
      it 'returns true if the value is 3' do
        input = '3'
        result = game.valid_input?(input)
        expect(result).to be(true)
      end

      it 'returns true if value is 1' do
        input = '3'
        result = game.valid_input?(input)
        expect(result).to be(true)
      end

      it 'returns true if value is 7' do
        input = '4'
        result = game.valid_input?(input)
        expect(result).to be(true)
      end
    end

    context 'if the input is invalid' do
      it 'returns false if the value is not a number' do
        invalid_input = 'hello'
        result = game.valid_input?(invalid_input)
        expect(result).to be(false)
      end
      it 'returns false if the value is not between 1 and 7' do
        invalid_input = '8'
        result = game.valid_input?(invalid_input)
        expect(result).to be(false)
      end
    end

    context 'if the column of the input value is full' do
      grid_val = [
        Array.new(7) { '@' },
        Array.new(7) { '' },
        Array.new(7) { '' },
        Array.new(7) { '' },
        Array.new(7) { '' },
        Array.new(7) { '' }
      ]
      let(:player1) { double('player') }
      let(:player2) { double('player') }
      let(:board) { double('board', grid: grid_val) }
      subject(:game_full) { described_class.new(player1, player2, board) }
      it 'returns false' do
        input = 6
        result = game_full.valid_input?(input)
        expect(result).to be(false)
      end
    end
  end

  describe '#player_input' do
    context 'when user typed two invalid inputs' do
      it 'display error message two times' do
        allow(game).to receive(:gets).and_return('winch', '100', '5')
        expect(game).to receive(:puts).with('enter a number from 1-7').exactly(3).times
        expect(game).to receive(:puts).with('Invalid Input!').twice
        game.player_input
      end
    end

    context 'when user did not typed any invalid inputs' do
      it 'does not display error message' do
        allow(game).to receive(:gets).and_return('4')
        expect(game).to receive(:puts).with('enter a number from 1-7').once
        expect(game).not_to receive(:puts).with('Invalid Input!')
        game.player_input
      end
    end
  end

  # describe '#horizontal_win?' do
  #   let(:player1) { double('player') }
  #   let(:player2) { double('player') }
  #   grid_val = [
  #     Array.new(7) { '' },
  #     Array.new(7) { '' },
  #     Array.new(7) { '' },
  #     Array.new(7) { '' },
  #     ['@', '@', '@', '@', '#', '#', '#'],
  #     ['@', '#', '@', '@', '#', '#', '#']
  #   ]
  #   let(:board) { double('board', grid: grid_val) }
  #   subject(:game_state) { described_class.new(player1, player2, board) }
  #   context 'when the grid has a four consecutive horizontal player piece' do
  #     it 'returns true' do
  #       expect { game_state.horizontal_win?('') }.to be(true)
  #     end
  #   end
  # end
end
# determine the exact coordinate each player turn
