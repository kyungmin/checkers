require 'colorize'
require_relative './piece'

module Checkers
  class Board
    attr_accessor :board

    def initialize
      @board = init_board
    end

    def init_board
      board = Array.new(8) { Array.new(8) { nil } }

      (0..2).each do |row|
        (0...board.length).each do |col|
          next if (col % 2) != (row % 2)
          board[row][col] = Piece.new([row, col], :black, board)
        end
      end

      (5..7).each do |row|
        (0...board.length).each do |col|
          next if (col % 2) != (row % 2)
          board[row][col] = Piece.new([row, col], :white, board)
        end
      end

      board
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

  end
end

checkers = Checkers::Board.new
checkers.show_board
#checkers.perform_moves([3,3], [4,4])