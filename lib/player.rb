# frozen_string_literal: true

# a class that handles player operations in the connect four game
class Player
  attr_accessor :piece

  def initialize(piece)
    @piece = piece
  end
end
