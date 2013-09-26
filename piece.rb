
module Checkers

  class InvalidMoveException < Exception
  end

  class Piece
    attr_accessor :color, :board

    def initialize(pos, color, board)
      @position, @color, @board = pos, color, board
    end

    def to_s
      color == :white ? "\u25EF" : "\u2B24"
    end

    # def perform_moves(start_pos, end_pos)
    #   if valid_slide_move?(start_pos, end_pos)
    #     perform_slide(start_pos, end_pos)
    #   elsif valid_jump_move?(start_pos, end_pos)
    #     perform_jump(start_pos, end_pos)
    #   else
    #     raise InvalidMoveException.new("Invalid move!")
    #   end
    # end
    #
    # def perform_moves!(move_sequence)
    # end
    #
    def slide_moves
      { :white => [[-1, 1], [-1, -1]], :black => [[1, 1], [1, -1]] }
    end

    def jump_moves
      { :white => [[-2, 2], [-2, -2]], :black => [[2, 2], [2, -2]] }
    end

  end
end
