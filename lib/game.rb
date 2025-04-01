# frozen_string_literal: true

require_relative 'player'
require_relative 'board'
# A class for the whole connect four game that use the player and board object
class ConnectFour
  attr_accessor :player1, :player2, :board

  def initialize(player1 = Player.new("\u2663"), player2 = Player.new("\u2665"), board = Board.new)
    @player1 = player1
    @player2 = player2
    @board = board
  end

  def valid_input?(input)
    input.to_i.between?(1, 7) && (board.grid[0][input.to_i - 1] == ' ')
  end

  def player_input
    loop do
      puts 'enter a number from 1-7'
      input = gets.chomp
      return (input.to_i - 1) if valid_input?(input)

      puts 'Invalid Input!'
    end
  end

  def row(column)
    board.grid.each_with_index do |curr_row, index|
      return (index - 1) unless curr_row[column] == ' '
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
    until row.negative? || column > 6
      return value if value == 4

      value += 1
      value = 0 unless board.grid[row][column] == piece
      row -= 1
      column += 1
    end
    value
  end

  def left_diagonal_count(row, column, piece)
    value = 0
    until row.negative? || column.negative?
      return value if value == 4

      value += 1
      value = 0 unless board.grid[row][column] == piece
      row -= 1
      column -= 1
    end
    value
  end

  def diagonal_win?(row, column, piece)
    left = left_diagonal_start(row, column)
    right = right_diagonal_start(row, column)
    right_count = right_diagonal_count(right[:row], right[:column], piece)
    left_count = left_diagonal_count(left[:row], left[:column], piece)

    right_count == 4 || left_count == 4
  end

  def player_win?(row, column, piece)
    horizontal_win?(row, piece) || vertical_win?(column, piece) || diagonal_win?(row, column, piece)
  end

  def place_piece(row, column, piece)
    @board.grid[row][column] = piece
  end

  def tie?
    !board.grid[0].include?(' ')
  end

  def game_over?(row, column, piece)
    if player_win?(row, column, piece)
      puts "player #{piece} won!"
      return true
    elsif tie?
      puts 'its a tie!'
      return true
    end
    false
  end

  def play
    current_player = player1
    board.show_board
    loop do
      puts "player #{current_player.piece} 's turn"
      column = player_input
      row = row(column)
      place_piece(row, column, current_player.piece)
      board.show_board
      break if game_over?(row, column, current_player.piece)

      current_player = current_player == player1 ? player2 : player1
    end
  end
end
# test = ConnectFour.new
# p test.right_diagonal_count(5, 1, '#')
