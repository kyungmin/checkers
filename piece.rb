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

    def perform_moves(start_pos, end_pos)
      raise InvalidMoveException.new("Out of range!") unless on_board?(start_pos, end_pos)

      if valid_slide_move?(start_pos, end_pos)
        perform_slide(start_pos, end_pos)
      elsif valid_jump_move?(start_pos, end_pos)
        perform_jump(start_pos, end_pos)
      else
        raise InvalidMoveException.new("Invalid move!")
      end
    end

    def perform_moves!(move_sequence)
    end

    def slide_moves
      { :white => [[-1, 1], [-1, -1]], :black => [[1, 1], [1, -1]] }
    end

    def jump_moves
      { :white => [[-2, 2], [-2, -2]], :black => [[2, 2], [2, -2]] }
    end

    def perform_slide(start_pos, end_pos)
      piece = board.piece(start_pos)
      board[start_pos] = nil
      board[end_pos] = piece
    end

    def perform_jump(start_pos, end_pos)
      mid_pos = [(start_pos[0] + end_pos [0]) / 2, (start_pos[1] + end_pos [1]) / 2]
      board[mid_pos] = nil

      perform_slide(start_pos, end_pos)
    end

    private


    def on_board?(start_pos, end_pos)
      move_sequence = [start_pos, end_pos]
      return false unless move_sequence.all? { |move| move[0].between?(0,7) && move[1].between?(0,7) }
      true
    end

    def valid_slide_move?(start_pos, end_pos)
      return false if board.occupied?(end_pos)

      valid_moves = []
      slide_moves[color].each do |valid_move|
        valid_moves << [start_pos[0] + valid_move[0], start_pos[1] + valid_move[1]]
      end
      return false unless valid_moves.include?(end_pos)
      true
    end

    def valid_jump_move?(start_pos, end_pos)
      return false if board.occupied?(end_pos)

      valid_moves = []
      jump_moves[color].each do |valid_move|
        valid_moves << [start_pos[0] + valid_move[0], start_pos[1] + valid_move[1]]
      end

      return false unless valid_moves.include?(end_pos)

      mid_pos = [(start_pos[0] + end_pos [0]) / 2, (start_pos[1] + end_pos [1]) / 2]
      false if board.occupied_by?(mid_pos, other_color(color))
      true
    end

    def other_color(color)
      color == :white ? :black : :white
    end
  end
end
