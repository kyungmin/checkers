require 'colorize'
require_relative './piece'
require_relative './king_piece.rb'

module Checkers

  class InvalidMoveException < Exception
  end

  class Board
    attr_accessor :board

    def initialize
      @board = init_board
    end

    def show_board
      background = [:white, :cyan]
      bg_toggle = 0
      puts "    a   b   c   d   e   f   g   h"
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

    def perform_moves(start_pos, end_pos)
      begin
        perform_moves!(start_pos, end_pos)
      rescue InvalidMoveException => e
        puts e.message
        false
      end
    end

    def perform_moves!(start_pos, end_pos)
      rails InvalidMoveException.new("Nothing there. Try again.") if piece(start_pos).nil?

      if valid_slide_move?(start_pos, end_pos)
        perform_slide(start_pos, end_pos)
      elsif valid_jump_move?(start_pos, end_pos)
        perform_jump(start_pos, end_pos)
        if jumps_available?(end_pos)
          raise InvalidMoveException.new("Make another jump.")
        end
      else
        raise InvalidMoveException.new("Invalid move.. Try again.")
      end
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

    def jumps_available?(start_pos)
      valid_moves = []
      piece = piece(start_pos)
      piece.jump_moves(piece.color).each do |offset|
        new_move = [start_pos[0] + offset[0], start_pos[1] + offset[1]]
        return true if valid_jump_move?(start_pos, new_move)
      end
      false
    end

    def won?(color)
      board.each do |row|
        return false if row.any? { |piece| piece && piece.color == color }
      end

      true
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
      !(start_pos + end_pos).all? { |coord| coord.between?(0,7) }
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
