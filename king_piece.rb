# require_relative './piece.rb'

module Checkers
  class KingPiece < Piece
    attr_accessor :color

    def initialize(pos, color)
      super(pos, color)
      @position, @color = pos, color
    end

    def to_s
      color == :white ? "\u25C9" : "\u25CE"
    end

    def slide_moves
      { :white => [[-1, 1], [-1, -1]], :black => [[1, 1], [1, -1]] }
    end

    def jump_moves
      { :white => [[-2, 2], [-2, -2]], :black => [[2, 2], [2, -2]] }
    end

  end
end