require 'colorize'
require_relative './piece'

module Checkers
  class Board
    attr_accessor :board

    def initialize
      @board = init_board
    end

    def move(start_pos, end_pos)
      piece = piece(start_pos)
      piece.perform_moves(start_pos, end_pos)
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

    def piece(pos)
      @board[pos[0]][pos[1]]
    end

    def []=(pos, value)
      @board[pos[0]][pos[1]] = value
    end

    def occupied?(pos)
      !piece(pos).nil?
    end

    def occupied_by?(pos, color)
      piece(pos) && piece(pos).color == color
    end

    private

    def init_board
      board = Array.new(8) { Array.new(8) { nil } }

      (0..2).each do |row|
        (0...board.length).each do |col|
          next if (col % 2) != (row % 2)
          board[row][col] = Piece.new([row, col], :black, self)
        end
      end

      (5..7).each do |row|
        (0...board.length).each do |col|
          next if (col % 2) != (row % 2)
          board[row][col] = Piece.new([row, col], :white, self)
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