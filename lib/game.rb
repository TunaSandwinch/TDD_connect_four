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

  def y_coordinate(x_coordinate)
    board.grid.each_with_index do |row, index|
      return (index - 1) unless row[x_coordinate] == ''
    end
    5
  end
end

test = ConnectFour.new
puts test.y_coordinate(1)
