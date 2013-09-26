require 'colorize'
require_relative './piece'
require_relative './king_piece.rb'

module Checkers
  class Board
    attr_accessor :board

    def initialize
      @board = init_board
    end

    def show_board
      background = [:white, :cyan]
      bg_toggle = 0
      puts "    1   2   3   4   5   6   7   8"
      board.each_with_index do |row, index|
        print " #{index+1} "
        row.each do |piece|
          print (piece ? " #{piece}  " : "    ").colorize(:color => :black, :background => background[bg_toggle])
          bg_toggle = (bg_toggle == 0 ? 1 : 0)
        end
        puts
        bg_toggle = (bg_toggle == 0 ? 1 : 0)
      end
    end

    def move(start_pos, end_pos)
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

    def perform_slide(start_pos, end_pos)
      piece = piece(start_pos)
      self[start_pos] = nil
      if conver_to_king?(end_pos, piece)
        self[end_pos] = KingPiece.new(end_pos, piece.color)
    else
        self[end_pos] = piece
      end
    end

    def perform_jump(start_pos, end_pos)
      mid_pos = [(start_pos[0] + end_pos [0]) / 2, (start_pos[1] + end_pos [1]) / 2]
      self[mid_pos] = nil

      perform_slide(start_pos, end_pos)
    end

    private

    def conver_to_king?(pos, piece)
      (pos[0] == 0) && (piece.color == :white) || (pos[0] == 7) && (piece.color == :black)
    end

    def valid_slide_move?(start_pos, end_pos)
      return false if occupied?(end_pos) || out_of_range?(start_pos, end_pos)

      piece = piece(start_pos)
      valid_moves = []
      piece.slide_moves(piece.color).each do |valid_move|
        valid_moves << [start_pos[0] + valid_move[0], start_pos[1] + valid_move[1]]
      end
      p end_pos, valid_moves
      valid_moves.include?(end_pos)
    end

    def valid_jump_move?(start_pos, end_pos)
      return false if occupied?(end_pos) || out_of_range?(start_pos, end_pos)

      valid_moves = []
      piece = piece(start_pos)
      piece.jump_moves(piece.color).each do |valid_move|
        valid_moves << [start_pos[0] + valid_move[0], start_pos[1] + valid_move[1]]
      end

      mid_pos = [(start_pos[0] + end_pos [0]) / 2, (start_pos[1] + end_pos [1]) / 2]
      return false if occupied_by?(mid_pos, piece.color)

      valid_moves.include?(end_pos)
    end

    def other_color(color)
      color == :white ? :black : :white
    end

    def out_of_range?(start_pos, end_pos)
      move_sequence = [start_pos, end_pos]
      !move_sequence.all? { |move| move[0].between?(0,7) && move[1].between?(0,7) }
    end

    def piece(pos)
      @board[pos[0]][pos[1]]
    end

    def []=(pos, value)
      i,j = pos
      @board[i][j] = value
    end

    def occupied?(pos)
      !piece(pos).nil?
    end

    def occupied_by?(pos, color)
      piece(pos) && piece(pos).color == color
    end

    def init_board
      board = Array.new(8) { Array.new(8) { nil } }

      (0..2).each do |row|
        (0...board.length).each do |col|
          next if (col % 2) != (row % 2)
          board[row][col] = Piece.new([row, col], :black)
        end
      end

      (5..7).each do |row|
        (0...board.length).each do |col|
          next if (col % 2) != (row % 2)
          board[row][col] = Piece.new([row, col], :white)
        end
      end

      board
    end

  end
end

checkers = Checkers::Board.new
checkers.show_board
checkers.move([2,2], [3,3])
checkers.show_board
checkers.move([5,3], [4,4])
checkers.show_board
checkers.move([4,4], [2,2])
checkers.show_board
checkers.move([2,4], [4,6])
checkers.show_board
checkers.move([1,3], [3,1])
checkers.show_board
checkers.move([1,5], [2,4])
checkers.show_board

checkers.move([5,5], [3,7])
checkers.show_board
checkers.move([3,7], [1,5])
checkers.show_board
checkers.move([0,4], [1,3])
checkers.show_board
checkers.move([1,5], [0,4])
checkers.show_board
checkers.move([0,4], [1,5])
checkers.show_board
checkers.move([1,5], [0,4])
checkers.show_board