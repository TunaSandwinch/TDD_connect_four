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
        Array.new(7) { ' ' },
        Array.new(7) { ' ' },
        Array.new(7) { ' ' },
        Array.new(7) { ' ' },
        Array.new(7) { ' ' }
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

  describe '#row' do # rubocop:disable Metrics/BlockLength
    context 'when board is empty' do
      let(:player1) { double('player') }
      let(:player2) { double('player') }
      grid_val = Array.new(6) { Array.new(7) { ' ' } }
      let(:board) { double('board', grid: grid_val) }
      subject(:game_coordinate) { described_class.new(player1, player2, board) }

      it 'returns 5 if column_num = 0' do
        result = game_coordinate.row(0)
        expect(result).to eq(5)
      end

      it 'returns 5 if column_num = 3' do
        result = game_coordinate.row(3)
        expect(result).to eq(5)
      end

      it 'return 5 if column_num = 6' do
        result = game_coordinate.row(6)
        expect(result).to eq(5)
      end
    end

    describe 'when row 3-5 is full' do
      let(:player1) { double('player') }
      let(:player2) { double('player') }
      grid_val = [
        Array.new(7) { ' ' },
        Array.new(7) { ' ' },
        Array.new(7) { ' ' },
        Array.new(7) { '#' },
        Array.new(7) { '#' },
        Array.new(7) { '#' }
      ]
      let(:board) { double('board', grid: grid_val) }
      subject(:game_coordinate) { described_class.new(player1, player2, board) }

      it 'returns 2 if column_num = 0' do
        result = game_coordinate.row(0)
        expect(result).to eq(2)
      end

      it 'returns 2 if column_num = 3' do
        result = game_coordinate.row(3)
        expect(result).to eq(2)
      end

      it 'returns 2 if column_num = 6' do
        result = game_coordinate.row(6)
        expect(result).to eq(2)
      end
    end
  end

  describe '#horizontal_win?' do # rubocop:disable Metrics/BlockLength
    let(:player1) { double('player') }
    let(:player2) { double('player') }
    grid_val = [
      Array.new(7) { ' ' },
      Array.new(7) { ' ' },
      Array.new(7) { ' ' },
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
  describe '#right_diagonal_start' do
    it 'returns { row: 5, column: 3 } if row = 4 and column = 4  ' do
      row = 4
      column = 4
      result = game.right_diagonal_start(row, column)
      expect(result).to eql({ row: 5, column: 3 })
    end

    it 'returns { row: 5, column: 6 } if row = 5 and column = 6' do
      row = 5
      column = 6
      result = game.right_diagonal_start(row, column)
      expect(result).to eql({ row: 5, column: 6 })
    end

    it 'returns { row: 5, column: 0 } if row = 5 and column = 0' do
      row = 5
      column = 0
      result = game.right_diagonal_start(row, column)
      expect(result).to eql({ row: 5, column: 0 })
    end

    it 'returns { row: 3, column: 0 } if row = 2 and column = 1' do
      row = 2
      column = 1
      result = game.right_diagonal_start(row, column)
      expect(result).to eql({ row: 3, column: 0 })
    end
  end

  describe '#left_diagonal_start' do
    it 'returns { row: 5, column: 5 } if row = 4 and column = 4' do
      row = 4
      column = 4
      result = game.left_diagonal_start(row, column)
      expect(result).to eql({ row: 5, column: 5 })
    end

    it 'returns { row: 5, column: 6 } if row = 5 and column = 6' do
      row = 5
      column = 6
      result = game.left_diagonal_start(row, column)
      expect(result).to eql({ row: 5, column: 6 })
    end

    it 'returns { row: 5, column: 0 } if row = 5 and column = 0' do
      row = 5
      column = 0
      result = game.left_diagonal_start(row, column)
      expect(result).to eql({ row: 5, column: 0 })
    end

    it 'returns [5, 4] if row = 2 and column = 1' do
      row = 2
      column = 1
      result = game.left_diagonal_start(row, column)
      expect(result).to eql({ row: 5, column: 4 })
    end
  end

  describe '#right_diagonal_count' do # rubocop:disable Metrics/BlockLength
    let(:player1) { double('player') }
    let(:player2) { double('player') }
    let(:board) { double('board', grid: grid_val) }
    subject(:game_status) { described_class.new(player1, player2, board) }

    context 'if the board has 4 consecutive right diagonal player piece' do
      let(:grid_val) do
        [
          ['X', 'X', 'X', 'X', 'X', 'X', '#'],
          ['X', 'X', 'X', 'X', 'X', '#', 'X'],
          ['X', 'X', 'X', '#', '#', 'X', 'X'],
          ['X', 'X', '#', 'X', 'X', 'X', 'X'],
          ['X', '#', 'X', 'X', 'X', 'X', 'X'],
          ['#', 'X', 'X', 'X', 'X', 'X', 'X']
        ]
      end
      it 'returns 4' do
        result = game_status.right_diagonal_count(5, 0, '#')
        expect(result).to eql(4)
      end
    end

    context 'if there is no consecutive 4 right diagonal player piece' do
      let(:grid_val) do
        [
          ['X', 'X', 'X', 'X', 'X', 'X', '#'],
          ['X', 'X', 'X', 'X', 'X', '#', 'X'],
          ['X', 'X', 'X', 'X', 'X', 'X', 'X'],
          ['X', 'X', 'X', '#', 'X', 'X', 'X'],
          ['X', 'X', 'X', 'X', 'X', 'X', 'X'],
          ['X', '#', 'X', 'X', 'X', 'X', 'X']
        ]
      end
      it 'returns a value less than 4' do
        result = game_status.right_diagonal_count(5, 1, '#')
        expect(result).to be < 4
      end
    end
  end

  describe '#left_diagonal_count' do # rubocop:disable Metrics/BlockLength
    let(:player1) { double('player') }
    let(:player2) { double('player') }
    let(:board) { double('board', grid: grid_val) }
    subject(:game_status) { described_class.new(player1, player2, board) }
    context 'if there is 4 consecutive right diagonal player piece' do
      let(:grid_val) do
        [
          ['X', 'X', 'X', 'X', 'X', 'X', 'X'],
          ['X', 'X', 'X', 'X', 'X', 'X', 'X'],
          ['X', 'X', '#', 'X', 'X', 'X', 'X'],
          ['X', 'X', 'X', '#', 'X', 'X', 'X'],
          ['X', 'X', 'X', 'X', '#', 'X', 'X'],
          ['X', 'X', 'X', 'X', 'X', '#', 'X']
        ]
      end
      it 'returns 4' do
        row = 5
        column = 5
        piece = '#'
        result = game_status.left_diagonal_count(row, column, piece)
        expect(result).to eql(4)
      end
    end

    context 'when there is no 4 consecutive left diagonal player piece' do
      let(:grid_val) do
        [
          ['X', 'X', 'X', 'X', 'X', 'X', 'X'],
          ['X', '#', 'X', 'X', 'X', 'X', 'X'],
          ['X', 'X', '#', 'X', 'X', 'X', 'X'],
          ['X', 'X', 'X', '#', 'X', 'X', 'X'],
          ['X', 'X', 'X', 'X', 'X', 'X', 'X'],
          ['X', 'X', 'X', 'X', 'X', '#', 'X']
        ]
      end
      it 'returns a value less than 4' do
        row = 5
        column = 5
        piece = '#'
        result = game_status.left_diagonal_count(row, column, piece)
        expect(result).to be < 4
      end
    end
  end

  describe '#diagonal_win?' do
    context 'when method is called' do
      before do
        allow(game).to receive(:left_diagonal_start).and_return({ row: 5, column: 5 })
        allow(game).to receive(:right_diagonal_start).and_return({ row: 5, column: 1 })
      end
      it 'calls left_diagonal_start once' do
        expect(game).to receive(:left_diagonal_start).once
        game.diagonal_win?(3, 3, '#')
      end

      it 'calls right_diagonal_start once' do
        expect(game).to receive(:right_diagonal_start).once
        game.diagonal_win?(3, 3, '#')
      end

      it 'calls left_diagonal_count once' do
        expect(game).to receive(:left_diagonal_count).once
        game.diagonal_win?(0, 0, '#')
      end

      it 'calls right_diagonal_count once' do
        expect(game).to receive(:right_diagonal_count).once
        game.diagonal_win?(2, 4, '#')
      end
    end
  end

  context 'if a player won in a right diagonal' do
    it 'returns true' do
      allow(game).to receive(:left_diagonal_start).and_return({ row: 5, column: 5 })
      allow(game).to receive(:right_diagonal_start).and_return({ row: 5, column: 1 })
      allow(game).to receive(:right_diagonal_count).and_return(4)
      allow(game).to receive(:left_diagonal_count).and_return(3)
      row = 3
      column = 3
      piece = '#'
      result = game.diagonal_win?(row, column, piece)
      expect(result).to be(true)
    end
  end

  context 'if a player won in a left diagonal' do
    it 'returns true' do
      allow(game).to receive(:left_diagonal_start).and_return({ row: 5, column: 5 })
      allow(game).to receive(:right_diagonal_start).and_return({ row: 5, column: 1 })
      allow(game).to receive(:right_diagonal_count).and_return(3)
      allow(game).to receive(:left_diagonal_count).and_return(4)
      row = 3
      column = 3
      piece = '#'
      result = game.diagonal_win?(row, column, piece)
      expect(result).to be(true)
    end
  end

  describe '#player_win?' do # rubocop:disable Metrics/BlockLength
    describe 'when called' do
      it 'calls horizontal_win? once' do
        expect(game).to receive(:horizontal_win?).once
        game.player_win?(3, 3, '#')
      end

      it 'calls vertical_win? once' do
        expect(game).to receive(:vertical_win?).once
        game.player_win?(3, 3, '#')
      end

      it 'calls diagonal_win? once' do
        expect(game).to receive(:diagonal_win?).once
        game.player_win?(3, 3, '#')
      end
    end

    describe 'if a player won horizontally' do
      it 'returns true' do
        allow(game).to receive(:horizontal_win?).and_return(true)
        allow(game).to receive(:vertical_win?).and_return(false)
        allow(game).to receive(:diagonal_win?).and_return(false)
        row = 3
        column = 3
        piece = '#'
        outcome = game.player_win?(row, column, piece)
        expect(outcome).to be(true)
      end
    end

    describe 'if a player won vertically' do
      it 'returns true' do
        allow(game).to receive(:horizontal_win?).and_return(false)
        allow(game).to receive(:vertical_win?).and_return(true)
        allow(game).to receive(:diagonal_win?).and_return(false)
        row = 3
        column = 3
        piece = '#'
        outcome = game.player_win?(row, column, piece)
        expect(outcome).to be(true)
      end
    end

    describe 'if a player won diagonally' do
      it 'returns true' do
        allow(game).to receive(:horizontal_win?).and_return(false)
        allow(game).to receive(:vertical_win?).and_return(false)
        allow(game).to receive(:diagonal_win?).and_return(true)
        row = 3
        column = 3
        piece = '#'
        outcome = game.player_win?(row, column, piece)
        expect(outcome).to be(true)
      end
    end

    describe 'if a player move did not make a winning condition' do
      it 'returns true' do
        allow(game).to receive(:horizontal_win?).and_return(false)
        allow(game).to receive(:vertical_win?).and_return(false)
        allow(game).to receive(:diagonal_win?).and_return(false)
        row = 3
        column = 3
        piece = '#'
        outcome = game.player_win?(row, column, piece)
        expect(outcome).to be(false)
      end
    end
  end

  describe '#place_piece' do
    it 'place the piece on the board' do
      row = 3
      column = 3
      piece = '#'
      game.place_piece(row, column, piece)
      expect(game.board.grid[row][column]).to eq(piece)
    end
  end

  describe '#tie?' do # rubocop:disable Metrics/BlockLength
    context 'when its a tie' do
      grid_val = [
        Array.new(7) { '@' },
        Array.new(7) { ' ' },
        Array.new(7) { ' ' },
        Array.new(7) { ' ' },
        Array.new(7) { ' ' },
        Array.new(7) { ' ' }
      ]
      let(:player1) { double('player') }
      let(:player2) { double('player') }
      let(:board) { double('board', grid: grid_val) }
      subject(:game_state) { described_class.new(player1, player2, board) }
      it 'returns true' do
        expect(game_state.tie?).to be(true)
      end
    end
    context 'when its not a tie' do
      grid_val = [
        Array.new(7) { ' ' },
        Array.new(7) { '@' },
        Array.new(7) { '@' },
        Array.new(7) { '@' },
        Array.new(7) { '@' },
        Array.new(7) { '@' }
      ]
      let(:player1) { double('player') }
      let(:player2) { double('player') }
      let(:board) { double('board', grid: grid_val) }
      subject(:game_state) { described_class.new(player1, player2, board) }
      it 'returns false' do
        expect(game_state.tie?).to be(false)
      end
    end
  end

  describe '#game_over?' do # rubocop:disable Metrics/BlockLength
    context 'the game is over' do # rubocop:disable Metrics/BlockLength
      it 'returns true if a player won' do
        row = 3
        column = 3
        piece = '#'
        allow(game).to receive(:player_win?).and_return(true)
        allow(game).to receive(:tie?).and_return(false)
        allow(game).to receive(:puts).with("player #{piece} won!")
        result = game.game_over?(row, column, piece)
        expect(result).to be(true)
      end

      it 'displays a message of who won if it is not a tie' do
        row = 3
        column = 3
        piece = '#'
        allow(game).to receive(:player_win?).and_return(true)
        allow(game).to receive(:tie?).and_return(false)
        expect(game).to receive(:puts).with("player #{piece} won!").once
        game.game_over?(row, column, piece)
      end

      it 'returns true if its a tie' do
        row = 3
        column = 3
        piece = '#'
        allow(game).to receive(:player_win?).and_return(false)
        allow(game).to receive(:tie?).and_return(true)
        allow(game).to receive(:puts).with('its a tie!')
        result = game.game_over?(row, column, piece)
        expect(result).to be(true)
      end

      it 'displays a message if it is a tie' do
        row = 3
        column = 3
        piece = '#'
        allow(game).to receive(:player_win?).and_return(false)
        allow(game).to receive(:tie?).and_return(true)
        expect(game).to receive(:puts).with('its a tie!').once
        game.game_over?(row, column, piece)
      end
    end

    context 'when the game is not over' do
      it 'returns false' do
        row = 3
        column = 3
        piece = '#'
        allow(game).to receive(:player_win?).and_return(false)
        allow(game).to receive(:tie?).and_return(false)
        result = game.game_over?(row, column, piece)
        expect(result).to be(false)
      end
    end
  end

  describe '#play' do
    let(:player1) { double('player', piece: '#') }
    let(:player2) { double('player', piece: '@') }
    let(:board) { double('board') }
    subject(:game_test) { described_class.new(player1, player2, board) }
    before do
      allow(board).to receive(:show_board)
      allow(game_test).to receive(:puts).with(anything)
      allow(game_test).to receive(:player_input).and_return(3)
      allow(game_test).to receive(:row).with(anything).and_return(3)
      allow(game_test).to receive(:place_piece).with(anything, anything, anything)
    end

    it 'calls game_over? before switching players' do
      allow(game_test).to receive(:game_over?).and_return(false, true)

      expect(game_test).to receive(:game_over?).at_least(:once)
      game_test.play
    end
  end
end
