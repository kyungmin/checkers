require_relative './board'

module Checkers

  class Game
    attr_accessor :board, :current_player
    GRID_MAP = {  "h" => 7, "g" => 6, "f" => 5, "e" => 4,
                  "d" => 3, "c" => 2, "b" => 1, "a" => 0,
                  "1" => 0, "2" => 1, "3" => 2, "4" => 3,
                  "5" => 4, "6" => 5, "7" => 6, "8" => 7 }

    def initialize
      @board = Checkers::Board.new
      @current_player = :black
    end

    def play
      until board.won?(:white) || board.won?(:black)
        board.show_board
        start_pos, end_pos = get_input
        change_player if board.perform_moves(start_pos, end_pos)
      end

      puts (won?(:white) ? "White won!" : "Black won!")
    end

    private

    def get_input
      puts "#{current_player.capitalize}: Enter move (e.g., a1b2..)."
      input = gets.chomp.gsub('/[^a-h1-8\s]/', "")
      start_pos = [GRID_MAP[input[0]], GRID_MAP[input[1]]]
      end_pos = [GRID_MAP[input[2]], GRID_MAP[input[3]]]
      [start_pos, end_pos]
    end

    def change_player
      @current_player = (current_player == :white ? :black : :white)
    end

  end
end

game = Checkers::Game.new
game.play