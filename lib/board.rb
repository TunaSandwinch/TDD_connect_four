# frozen_string_literal: true

# board class for connect four game
class Board
  attr_accessor :grid

  def initialize
    @grid = [
      Array.new(7) { '' },
      Array.new(7) { '' },
      Array.new(7) { '' },
      Array.new(7) { '' },
      Array.new(7) { '' },
      Array.new(7) { '' }
    ]
  end
end
