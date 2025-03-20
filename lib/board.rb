# frozen_string_literal: true

# board class for connect four game
class Board
  def initialize
    @board = [
      Array.new(7) { '' },
      Array.new(7) { '' },
      Array.new(7) { '' },
      Array.new(7) { '' },
      Array.new(7) { '' },
      Array.new(7) { '' }
    ]
  end
end
