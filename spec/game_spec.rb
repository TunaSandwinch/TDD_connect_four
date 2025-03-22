# frozen_string_literal: true

require_relative '../lib/game'

describe ConnectFour do # rubocop:disable Metrics/BlockLength
  subject(:game) { described_class.new }

  describe 'when initialized' do
    it 'has player1 instance variable with a Player object value' do
      player1 = game.instance_variable_get(:@player1)
      expect(player1).to be_a(Player)
    end

    it 'has player2 instance variable with a Player object value' do
      player2 = game.instance_variable_get(:@player2)
      expect(player2).to be_a(Player)
    end

    it 'has a board instance variable with a Board object value' do
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

  describe '#player_input' do # rubocop:disable Metrics/BlockLength
    it 'returns integer data type' do
      allow(game).to receive(:gets).and_return('5')
      allow(game).to receive(:puts).and_return('enter a number from 1 - 7')
      result = game.player_input
      expect(result).to be_an(Integer)
    end

    it 'returns an integer value that is minus 1 from the original input' do
      allow(game).to receive(:gets).and_return('1')
      allow(game).to receive(:puts).and_return('enter a number from 1 - 7')
      result = game.player_input
      expect(result).to eq(0)
    end

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

  describe '#y_coordinate' do # rubocop:disable Metrics/BlockLength
    context 'when board is empty' do
      let(:player1) { double('player') }
      let(:player2) { double('player') }
      grid_val = Array.new(6) { Array.new(7) { '' } }
      let(:board) { double('board', grid: grid_val) }
      subject(:game_coordinate) { described_class.new(player1, player2, board) }

      it 'returns 5 if x_coordinate = 0' do
        result = game_coordinate.y_coordinate(0)
        expect(result).to eq(5)
      end

      it 'returns 5 if x_coordinate = 3' do
        result = game_coordinate.y_coordinate(3)
        expect(result).to eq(5)
      end

      it 'return 5 if x_coordinate = 6' do
        result = game_coordinate.y_coordinate(6)
        expect(result).to eq(5)
      end
    end

    describe 'when row 3-5 is full' do
      let(:player1) { double('player') }
      let(:player2) { double('player') }
      grid_val = [
        Array.new(7) { '' },
        Array.new(7) { '' },
        Array.new(7) { '' },
        Array.new(7) { '#' },
        Array.new(7) { '#' },
        Array.new(7) { '#' }
      ]
      let(:board) { double('board', grid: grid_val) }
      subject(:game_coordinate) { described_class.new(player1, player2, board) }

      it 'returns 2 if x_coordinate = 0' do
        result = game_coordinate.y_coordinate(0)
        expect(result).to eq(2)
      end

      it 'returns 2 if x_coordinate = 3' do
        result = game_coordinate.y_coordinate(3)
        expect(result).to eq(2)
      end

      it 'returns 2 if x_coordinate = 6' do
        result = game_coordinate.y_coordinate(6)
        expect(result).to eq(2)
      end
    end
  end

  describe '#horizontal_win?' do # rubocop:disable Metrics/BlockLength
    let(:player1) { double('player') }
    let(:player2) { double('player') }
    grid_val = [
      Array.new(7) { '' },
      Array.new(7) { '' },
      Array.new(7) { '' },
      ['#', '#', '#', '#', '@', '@', '@'],
      ['#', '@', '@', '@', '@', '#', '#'],
      ['@', '#', '@', '@', '#', '#', '#']
    ]
    let(:board) { double('board', grid: grid_val) }
    subject(:game_state) { described_class.new(player1, player2, board) }

    context 'when the grid has a four consecutive horizontal player piece' do
      it 'returns true' do
        y_coordinate = 3
        player_piece = '#'
        result = game_state.horizontal_win?(y_coordinate, player_piece)
        expect(result).to be(true)
      end
    end

    context 'when the four consecutive horizontal player piece is in between the other piece' do
      it 'returns true' do
        y_coordinate = 4
        player_piece = '@'
        result = game_state.horizontal_win?(y_coordinate, player_piece)
        expect(result).to be(true)
      end
    end

    context 'when there is no four consecutive horizontal player piece' do
      it 'returns false' do
        y_coordinate = 5
        player_piece = '#'
        result = game_state.horizontal_win?(y_coordinate, player_piece)
        expect(result).to be(false)
      end
    end
  end

  describe '#vertical_win?' do # rubocop:disable Metrics/BlockLength
    let(:player1) { double('player') }
    let(:player2) { double('player') }
    grid_val = [
      ['X', 'X', 'X', '#', '#', 'X', '#'],
      ['X', '#', 'X', 'X', 'X', '#', '#'],
      ['#', '#', '#', '#', 'X', 'X', '#'],
      ['#', '#', '#', 'X', 'X', 'X', '#'],
      ['#', '#', '#', '#', 'X', 'X', 'X'],
      ['#', 'X', '#', 'X', 'X', 'X', 'X']
    ]
    let(:board) { double('board', grid: grid_val) }
    subject(:game_state) { described_class.new(player1, player2, board) }
    context 'when there is 4 consecutive vertical player piece in the board' do
      it 'returns true' do
        x_coordinate = 0
        player_piece = '#'
        result = game_state.vertical_win?(x_coordinate, player_piece)
        expect(result).to be(true)
      end

      it 'returns true in a full column' do
        x_coordinate = 6
        player_piece = '#'
        result = game_state.vertical_win?(x_coordinate, player_piece)
        expect(result).to be(true)
      end
    end
    context 'when there is no 4 consecutive vertical player piece in the board' do
      it 'return false' do
        x_coordinate = 3
        player_piece = '#'
        result = game_state.vertical_win?(x_coordinate, player_piece)
        expect(result).to be(false)
      end
    end
  end
end
