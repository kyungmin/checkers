# require_relative './king_piece.rb'

module Checkers

  class Piece
    attr_accessor :color

    def initialize(pos, color)
      @position, @color, @board = pos, color
    end

    def to_s
      color == :white ? "\u25EF" : "\u2B24"
    end

    def slide_moves(color)
      offset = { :white => [[-1, 1], [-1, -1]], :black => [[1, 1], [1, -1]] }
      offset[color]
    end

    def jump_moves(color)
      offset = { :white => [[-2, 2], [-2, -2]], :black => [[2, 2], [2, -2]] }
      offset[color]
    end

  end
end
