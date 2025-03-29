# frozen_string_literal: true

require_relative 'player'
require_relative 'board'
# A class for the whole connect four game that use the player and board object
class ConnectFour
  attr_reader :player1, :player2, :board

  def initialize(player1 = Player.new("\u2605"), player2 = Player.new("\u2665"), board = Board.new)
    @player1 = player1
    @player2 = player2
    @board = board
  end

  def valid_input?(input)
    input.to_i.between?(1, 7) && (board.grid[0][input.to_i] == '')
  end

  def player_input
    loop do
      puts 'enter a number from 1-7'
      input = gets.chomp
      return (input.to_i - 1) if valid_input?(input)

      puts 'Invalid Input!'
    end
  end

  def row_num(column_num)
    board.grid.each_with_index do |row, index|
      return (index - 1) unless row[column_num] == ''
    end
    5
  end

  def horizontal_win?(row, piece)
    value = 0
    board.grid[row].each do |item|
      if item == piece
        value += 1
      else
        value = 0
      end
      return true if value == 4
    end
    false
  end

  def vertical_win?(column, piece)
    value = 0
    (0..5).each do |row|
      if board.grid[row][column] == piece
        value += 1
      else
        value = 0
      end
      return true if value == 4
    end
    false
  end

  def right_diagonal_start(row, column)
    return { row: row, column: column } if row >= 5 || column <= 0

    right_diagonal_start(row + 1, column - 1)
  end

  def left_diagonal_start(row, column)
    return { row: row, column: column } if row >= 5 || column >= 6

    left_diagonal_start(row + 1, column + 1)
  end

  def right_diagonal_count(row, column, piece)
    value = 0
    count = lambda do |curr_row, curr_column|
      return 1 if curr_row.negative? || curr_column > 6

      value = 0 unless piece == board.grid[curr_row][curr_column]
      value += 1
      count.call(curr_row - 1, curr_column + 1)
    end
    count.call(row, column)
    value
  end
end
# test = ConnectFour.new
# p test.vertical_win?(0, '#')
