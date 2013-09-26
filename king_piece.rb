require_relative './piece.rb'
module Checkers
  class KingPiece < Piece
    attr_accessor :color

    def initialize(pos, color, board)
      @position, @color, @board = pos, color, board
    end

    def to_s
      color == :white ? "\u20DD" : "\u25C9"
    end

    private

    def valid_move_seq?
    end
  end
end