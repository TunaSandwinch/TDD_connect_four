# frozen_string_literal: true

require_relative 'player'
require_relative 'board'
# A class for the whole connect four game that use the player and board object
class ConnectFour
  def initialize(player1 = Player.new("\u2605"), player2 = Player.new("\u2665"), board = Board.new)
    @player1 = player1
    @player2 = player2
    @board = board
  end

  def valid_input?(input)
    input.to_i.between?(1, 7)
  end

  def player_input
    loop do
      puts 'enter a number from 1-7'
      input = gets.chomp
      return input if valid_input?(input)

      puts 'Invalid Input!'
    end
  end
end
