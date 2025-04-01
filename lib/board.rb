# frozen_string_literal: true

# board class for connect four game
class Board
  attr_accessor :grid

  def initialize
    @grid = [
      Array.new(7) { ' ' },
      Array.new(7) { ' ' },
      Array.new(7) { ' ' },
      Array.new(7) { ' ' },
      Array.new(7) { ' ' },
      Array.new(7) { ' ' }
    ]
  end

  def show_board
    system('clear') || system('cls') # Clears the terminal for a cleaner display
    puts ''
    puts ''
    @grid.each do |row|
      puts '| ' + row.join(' | ') + ' |'
    end
    puts '  1   2   3   4   5   6   7  ' # Column numbers for guidance
  end
end
